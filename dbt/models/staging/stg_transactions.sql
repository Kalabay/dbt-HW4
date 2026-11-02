with cleaned as (
    select
        transaction_id,
        toDateTime(transaction_time) as transaction_time,
        trimBoth(merch) as merchant,
        lower(trimBoth(cat_id)) as category,
        toDecimal64(toString(round(amount, 2)), 2) as amount,
        trimBoth(name_1) as first_name,
        trimBoth(name_2) as last_name,
        trimBoth(street) as street,
        trimBoth(one_city) as city,
        upper(trimBoth(gender)) as gender,
        upper(trimBoth(us_state)) as state,
        trimBoth(post_code) as post_code,
        lat,
        lon,
        merchant_lat,
        merchant_lon,
        toUInt8(target) as target
    from {{ source('raw', 'transactions') }}
)

select
    *,
    {{ dbt_utils.generate_surrogate_key(['first_name', 'last_name', 'street', 'city', 'state', 'post_code']) }} as customer_id,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.date_part('hour', 'transaction_time') }} as transaction_hour,
    toDayOfWeek(transaction_time) as day_of_week,
    {{ amount_bucket('amount') }} as amount_group
from cleaned
