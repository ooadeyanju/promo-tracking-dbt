-- One row per promotion from the projections spreadsheet.
-- Adds status (as of the last date with sales data), a trackable flag,
-- and projections converted to a daily rate based on Measure.

with promos as (
    select * from {{ ref('stg_promotion_projections') }}
),

as_of as (
    select max(business_date) as as_of_date
    from {{ ref('stg_digital_checks') }}
),

final as (
    select
        p.promo_id,
        p.promo_name,
        p.month_year,
        p.promo_type,
        p.country,
        p.start_date,
        p.end_date,
        (p.end_date - p.start_date + 1)                          as days_in_promo,
        p.redeemable_ids_raw                                     as redeemable_ids,
        case
            when p.start_date is null          then 'Not Scheduled'
            when p.start_date > a.as_of_date   then 'Upcoming'
            when p.end_date   < a.as_of_date   then 'Ended'
            else 'Ongoing'
        end                                                      as status,
        (p.start_date is not null
         and p.end_date is not null
         and p.redeemable_ids_raw is not null)                   as is_trackable,
        p.measure,
        p.txn_low, p.txn_medium, p.txn_high,
        p.gm_low,  p.gm_med,     p.gm_high,
        case p.measure
            when 'Campaign' then (p.end_date - p.start_date + 1)
            when 'PerWeek'  then 7
            when 'PerYear'  then 365
        end                                                      as projection_period_days
    from promos p
    cross join as_of a
)

select
    *,
    txn_low    / nullif(projection_period_days, 0)  as proj_txn_low_daily,
    txn_medium / nullif(projection_period_days, 0)  as proj_txn_medium_daily,
    txn_high   / nullif(projection_period_days, 0)  as proj_txn_high_daily,
    gm_low     / nullif(projection_period_days, 0)  as proj_gm_low_daily,
    gm_med     / nullif(projection_period_days, 0)  as proj_gm_med_daily,
    gm_high    / nullif(projection_period_days, 0)  as proj_gm_high_daily
from final