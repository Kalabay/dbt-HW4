select * from {{ ref('stg_transactions') }} where abs(lat) > 90 or abs(lon) > 180 or abs(merchant_lat) > 90 or abs(merchant_lon) > 180
