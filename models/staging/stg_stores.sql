-- Transactions carry the system store_id; locations maps it to the business store_number,
-- and stores adds country (US/CA) and region.

with locations as (
    select * from {{ source('loyalty', 'locations') }}
),

stores as (
    select * from {{ source('loyalty', 'stores') }}
)

select
    l.store_id,
    s.store_number,
    s.state_province,
    s.country,
    s.region,
    s.open_date
from locations l
join stores s
    on l.store_number = s.store_number
