select 'low' as customer_id, 10 as amount, 0 as target, toDateTime('2020-01-01 12:00:00') as transaction_time from numbers(100)
union all
select 'medium', 10, toUInt8(number < 1), toDateTime('2020-01-01 12:00:00') from numbers(100)
union all
select 'high', 10, toUInt8(number < 5), toDateTime('2020-01-01 12:00:00') from numbers(100)
