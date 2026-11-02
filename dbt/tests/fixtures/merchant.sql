select 'normal' as merchant, 10 as amount, 0 as target from numbers(20)
union all
select 'border', 10, toUInt8(number = 0) from numbers(20)
