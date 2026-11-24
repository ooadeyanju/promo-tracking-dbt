-- Finds digital checks that used each promotion's redeemable IDs
-- within the promotion's dates and country.
-- Each check counts once per promotion (the lowest redeemable_id is kept).

with promo_ids as (
    select * from {{ ref('int_promo_projections') }}
),

check_redeemables as (
    select * from {{ ref('stg_digital_check_redeemables') }}
),

checks as (
    select * from {{ ref('stg_digital_checks') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

matched as (
    select
        p.promo_id,
        cr.redeemable_id,
        c.check_key,
        c.business_date,
        c.store_number,
        c.net_sales,
        c.gross_margin
    from check_redeemables cr
    join promo_ids p  on cr.redeemable_id = p.redeemable_id       -- the check used this promo's offer
    join checks c     on cr.check_key     = c.check_key           -- get date, store, sales, margin
    join stores s     on c.store_number   = s.store_number        -- valid stores only
    where c.business_date between p.start_date and p.end_date     -- only during the promo
      and s.country = p.country                                   -- matching country
),

ranked as (
    select
        *,
        row_number() over (
            partition by promo_id, check_key                      -- one row per promo per check
            order by redeemable_id
        ) as rn
    from matched
)

select
    promo_id,
    redeemable_id,
    check_key,
    business_date,
    store_number,
    net_sales,
    gross_margin
from ranked
where rn = 1
