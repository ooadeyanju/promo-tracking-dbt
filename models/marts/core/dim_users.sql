-- One row per loyalty user with activity summary and Active / Lapsed status.
-- Active = a loyalty check-in in the last 30 days OR signed up in the last 30 days
-- (as of the last check-in date in the data).

with users as (
    select * from {{ ref('stg_users') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

activity as (
    select
        user_id,
        min(checkin_date)          as first_checkin_date,
        max(checkin_date)          as last_checkin_date,
        count(distinct check_key)  as loyalty_checks
    from {{ ref('stg_check_ins') }}
    where is_loyalty
    group by user_id
),

as_of as (
    select max(checkin_date) as as_of_date from {{ ref('stg_check_ins') }}
)

select
    u.user_id,
    u.signup_date,
    s.store_number                                   as home_store_number,
    a.first_checkin_date,
    a.last_checkin_date,
    coalesce(a.loyalty_checks, 0)                    as loyalty_checks,
    (o.as_of_date - a.last_checkin_date)             as days_since_last_checkin,
    case
        when a.last_checkin_date >= o.as_of_date - 30  then 'Active'
        when u.signup_date       >= o.as_of_date - 30  then 'Active'
        else 'Lapsed'
    end                                              as user_status
from users u
left join activity a on u.user_id = a.user_id
left join stores s   on u.home_store_id = s.store_id
cross join as_of o