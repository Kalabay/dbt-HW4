import argparse
import csv
import json
from datetime import datetime
import math
import time

from confluent_kafka import Producer
import os

from db import query


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", nargs="?", default="data/train.csv")
    args = parser.parse_args()
    producer = Producer({"bootstrap.servers": os.getenv("KAFKA_BROKERS", "kafka:9092"), "linger.ms": 20})
    errors = []

    def delivered(error, message):
        if error:
            errors.append(str(error))

    count = 0
    with open(args.file, encoding="utf-8-sig", newline="") as file:
        for count, row in enumerate(csv.DictReader(file), 1):
            data = dict(row)
            data["transaction_id"] = count
            data["transaction_time"] = datetime.fromisoformat(row["transaction_time"]).strftime("%Y-%m-%d %H:%M:%S")
            for field in ["amount", "lat", "lon", "merchant_lat", "merchant_lon"]:
                data[field] = float(row[field])
                if not math.isfinite(data[field]):
                    raise ValueError(f"invalid {field}: {count}")
            data["target"] = int(row["target"])
            data["population_city"] = int(row["population_city"])
            if data["target"] not in [0, 1] or data["amount"] < 0:
                raise ValueError(f"invalid row: {count}")
            while True:
                try:
                    producer.produce("transactions", json.dumps(data).encode(), on_delivery=delivered)
                    break
                except BufferError:
                    producer.poll(0.1)
            producer.poll(0)
            if errors:
                raise RuntimeError(errors[0])
    if producer.flush(120) or errors:
        raise RuntimeError(f"send failed: {errors[:1]}")
    deadline = time.monotonic() + 300
    while time.monotonic() < deadline:
        loaded = int(query("SELECT count() FROM transactions_db.transactions FINAL").text)
        if loaded == count:
            print(f"ready: {count}")
            return
        time.sleep(2)
    raise RuntimeError(f"loaded {loaded}, expected {count}")


if __name__ == "__main__":
    main()
