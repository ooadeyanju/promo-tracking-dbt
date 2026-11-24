-- One row per check (check_key). Reports filter to loyalty check-ins; gift check-ins never redeem offers.

with source as (
    select * from {{ source('loyalty', 'check_in') }}
)

select
    check_key,
    user_id,
    store_id,
    checkin_ts,
    checkin_ts::date             as checkin_date,
    order_total,
    status,
    (status = 'loyalty')         as is_loyalty
from source
