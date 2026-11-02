.PHONY: up load build test lint docs check
up:
	docker compose --profile tools build
	docker compose up -d
load:
	docker compose run --rm tools python send.py
build:
	docker compose run --rm dbt deps
	docker compose run --rm dbt build
test:
	docker compose run --rm dbt test
lint:
	docker compose run --rm --entrypoint sqlfluff dbt lint models tests
docs:
	docker compose run --rm dbt docs generate
	docker compose --profile docs up -d docs
check: build lint
