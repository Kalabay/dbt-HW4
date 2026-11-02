select * from {{ ref('stg_transactions') }} where day_of_week not between 1 and 7 or transaction_hour not between 0 and 23
