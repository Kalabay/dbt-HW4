select
    merchant,
    count() as transactions,
    sum(target) as frauds,
    100.0 * sum(target) / count() as fraud_rate,
    sum(amount) as total_amount,
    sumIf(amount, target = 1) as fraud_amount,
    toUInt8(100.0 * sum(target) / count() >= {{ var('high_risk') }}) as suspicious
from {{ ref('stg_transactions') }}
group by merchant
