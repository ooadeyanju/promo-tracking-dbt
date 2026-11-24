-- Calendar table covering all sales data and all promotion dates.

with bounds as (
    select
        (select min(business_date) from {{ ref('stg_digital_checks') }})     as start_date,
        greatest(
            (select max(business_date) from {{ ref('stg_digital_checks') }}),
            (select max(end_date)      from {{ ref('stg_promotion_projections') }})
        )                                                                     as end_date
),

dates as (
    select generate_series(start_date, end_date, interval '1 day')::date as date_day
    from bounds
)

select
    date_day,
    extract(year    from date_day)::int           as year,
    extract(quarter from date_day)::int           as quarter,
    extract(month   from date_day)::int           as month_number,
    to_char(date_day, 'Mon')                      as month_name,
    date_trunc('month', date_day)::date           as month_start,
    date_trunc('week',  date_day)::date           as week_start,
    extract(isodow  from date_day)::int           as day_of_week,
    to_char(date_day, 'Dy')                       as day_name,
    extract(isodow  from date_day) in (6, 7)      as is_weekend
from dates