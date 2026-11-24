with source as (
    select * from {{ source('loyalty', 'user_profile') }}
)

select
    user_id,
    signup_date,
    home_store_id
from source
