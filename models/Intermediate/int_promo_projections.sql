-- Splits the comma-separated RedeemableIDs from the projections spreadsheet
-- into one row per promotion per redeemable ID. Only trackable promos
-- (with dates and IDs) are kept.

with promos as (
    select * from {{ ref('stg_promotion_projections') }}
    where start_date is not null          
      and redeemable_ids_raw is not null
            
),

split as (
    select
        promo_id,
        start_date,
        end_date,
        country,
        unnest(string_to_array(redeemable_ids_raw, ',')) as redeemable_id_text   
    from promos
)

select
    promo_id,
    trim(redeemable_id_text )::int as redeemable_id,   
    start_date,
    end_date,
    country
from split
