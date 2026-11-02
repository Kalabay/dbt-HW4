CREATE DATABASE IF NOT EXISTS transactions_db;
CREATE TABLE IF NOT EXISTS transactions_db.transactions
(
    transaction_id UInt64,
    transaction_time DateTime,
    merch String,
    cat_id String,
    amount Float64,
    name_1 String,
    name_2 String,
    gender String,
    street String,
    one_city String,
    us_state String,
    post_code String,
    lat Float64,
    lon Float64,
    population_city UInt64,
    jobs String,
    merchant_lat Float64,
    merchant_lon Float64,
    target UInt8
)
ENGINE = ReplacingMergeTree
ORDER BY transaction_id;
CREATE TABLE IF NOT EXISTS transactions_db.kafka_transactions
(
    transaction_id UInt64,
    transaction_time DateTime,
    merch String,
    cat_id String,
    amount Float64,
    name_1 String,
    name_2 String,
    gender String,
    street String,
    one_city String,
    us_state String,
    post_code String,
    lat Float64,
    lon Float64,
    population_city UInt64,
    jobs String,
    merchant_lat Float64,
    merchant_lon Float64,
    target UInt8
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'transactions',
    kafka_group_name = 'dbt-homework',
    kafka_format = 'JSONEachRow',
    kafka_num_consumers = 1;
CREATE MATERIALIZED VIEW IF NOT EXISTS transactions_db.read_kafka
TO transactions_db.transactions AS
SELECT * FROM transactions_db.kafka_transactions;
