-- One row per redemption. Includes EVERY offer, whether or not it's on the projections spreadsheet.

with source as (
    select * from {{ source('loyalty', 'offer_redemption') }}
)

select
    redemption_id,
    check_key,
    user_id,
    redeemable_id,
    redeemed_ts,
    redeemed_ts::date            as redeemed_date,
    discount_amount
from source
