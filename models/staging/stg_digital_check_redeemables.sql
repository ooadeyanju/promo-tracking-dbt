-- Which redeemables were used on each digital check. One row per check per redeemable.

with source as (
    select * from {{ source('pos', 'digital_check_redeemables') }}
)

select distinct
    check_key,
    redeemable_id
from source
