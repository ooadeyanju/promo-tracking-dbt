select
    store_number,
    store_id,
    state_province,
    country,
    region,
    open_date
from {{ ref('stg_stores') }}