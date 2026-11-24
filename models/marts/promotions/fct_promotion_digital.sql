-- Daily promotion results: one row per date, store, promotion and redeemable ID.
-- Checks are counted as distinct check keys (each check already counted once per promo).

with promo_checks as (
    select * from {{ ref('int_promo_stats') }}
)

select
    business_date,
    store_number,
    promo_id,
    redeemable_id,
    count(distinct check_key)   as checks,
    sum(net_sales)              as net_sales,
    sum(gross_margin)           as gross_margin
from promo_checks
group by
    business_date,
    store_number,
    promo_id,
    redeemable_id