select
    state,
    count() as transactions,
    sum(target) as frauds,
    100.0 * sum(target) / count() as fraud_rate,
    uniqExact(customer_id) as customers,
    uniqExact(merchant) as merchants,
    sum(amount) as total_amount,
    sumIf(amount, target = 1) as fraud_amount
from {{ ref('stg_transactions') }}
group by state
