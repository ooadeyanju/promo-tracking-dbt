-- One row per offer redemption (all offers, tracked or not), with the store it happened at.

with redemptions as (
    select * from {{ ref('stg_redemptions') }}
),

checkins as (
    select check_key, store_id from {{ ref('stg_check_ins') }}
),

stores as (
    select store_id, store_number from {{ ref('stg_stores') }}
)

select
    r.redemption_id,
    r.redeemed_date,
    r.redeemed_ts,
    r.check_key,
    r.user_id,
    r.redeemable_id,
    s.store_number,
    r.discount_amount
from redemptions r
join checkins c on r.check_key = c.check_key
join stores s   on c.store_id  = s.store_id