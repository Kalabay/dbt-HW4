select 'mart_daily_state_metrics' as model where (select sum(transactions) from {{ ref('mart_daily_state_metrics') }}) != (select count() from {{ ref('stg_transactions') }})
union all
select 'mart_fraud_by_category' as model where (select sum(transactions) from {{ ref('mart_fraud_by_category') }}) != (select count() from {{ ref('stg_transactions') }})
union all
select 'mart_fraud_by_state' as model where (select sum(transactions) from {{ ref('mart_fraud_by_state') }}) != (select count() from {{ ref('stg_transactions') }})
union all
select 'mart_customer_risk_profile' as model where (select sum(transactions) from {{ ref('mart_customer_risk_profile') }}) != (select count() from {{ ref('stg_transactions') }})
union all
select 'mart_hourly_fraud_pattern' as model where (select sum(transactions) from {{ ref('mart_hourly_fraud_pattern') }}) != (select count() from {{ ref('stg_transactions') }})
union all
select 'mart_merchant_analytics' as model where (select sum(transactions) from {{ ref('mart_merchant_analytics') }}) != (select count() from {{ ref('stg_transactions') }})
