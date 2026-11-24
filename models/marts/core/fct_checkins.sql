-- One row per loyalty-app check (loyalty and gift), with store number and redemption counts.

with checkins as (
    select * from {{ ref('stg_check_ins') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

redemptions as (
    select check_key, count(*) as redemption_count
    from {{ ref('stg_redemptions') }}
    group by check_key
)

select
    c.check_key,
    c.checkin_date,
    c.checkin_ts,
    c.user_id,
    s.store_number,
    c.order_total,
    c.status,
    c.is_loyalty,
    coalesce(r.redemption_count, 0)       as redemption_count,
    (r.check_key is not null)             as has_redemption
from checkins c
join stores s           on c.store_id  = s.store_id     -- inner join: valid stores only
left join redemptions r on c.check_key = r.check_key