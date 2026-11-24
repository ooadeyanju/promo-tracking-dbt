-- Marketing's PromotionProjections spreadsheet, loaded as a dbt seed.
-- Cleans text, converts M/D/YYYY text dates to real dates, and keeps the raw ID list for splitting later.

with source as (
    select * from {{ ref('promotion_projections') }}
)

select
    promoid::int                                          as promo_id,
    nullif(trim(monthyear), '')                           as month_year,
    trim(name)                                            as promo_name,
    nullif(trim(promotype), '')                           as promo_type,
    trim(country)                                         as country,
    nullif(trim(baseline), '')::numeric                   as baseline,
    txnlow::numeric                                       as txn_low,
    txnmedium::numeric                                    as txn_medium,
    txnhigh::numeric                                      as txn_high,
    gmlow::numeric                                        as gm_low,
    gmmed::numeric                                        as gm_med,
    gmhigh::numeric                                       as gm_high,
    nullif(trim(measure), '')                             as measure,
    to_date(nullif(trim(startdate), ''), 'MM/DD/YYYY')    as start_date,
    to_date(nullif(trim(enddate), ''), 'MM/DD/YYYY')      as end_date,
    nullif(trim(redeemableids), '')                       as redeemable_ids_raw
from source
