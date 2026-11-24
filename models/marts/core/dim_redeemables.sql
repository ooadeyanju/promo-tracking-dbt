-- One row per redeemable (offer), with a flag for offers tracked on the projections spreadsheet.

with redeemables as (
    select * from {{ ref('stg_redeemables') }}
),

tracked as (
    select distinct redeemable_id from {{ ref('int_promo_projections') }}
)

select
    r.redeemable_id,
    r.criterion_id,
    r.redeemable_name,
    r.plu_id,
    r.redeemable_name_raw,
    (t.redeemable_id is not null)   as is_tracked_promo
from redeemables r
left join tracked t on r.redeemable_id = t.redeemable_id
