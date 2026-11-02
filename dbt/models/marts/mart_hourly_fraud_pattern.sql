select
    day_of_week,
    transaction_hour,
    count() as transactions,
    sum(target) as frauds,
    100.0 * sum(target) / count() as fraud_rate,
    sum(amount) as total_amount
from {{ ref('stg_transactions') }}
group by day_of_week, transaction_hour
