with metrics as (
    select
        customer_id,
        count() as transactions,
        sum(target) as frauds,
        100.0 * sum(target) / count() as fraud_rate,
        sum(amount) as total_amount,
        avg(amount) as average_amount,
        min(transaction_time) as first_transaction,
        max(transaction_time) as last_transaction
    from {{ ref('stg_transactions') }}
    group by customer_id
)

select
    *,
    {{ risk_level('fraud_rate') }} as risk_level
from metrics
