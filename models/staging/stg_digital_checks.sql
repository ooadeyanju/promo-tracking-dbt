-- One row per digital check (loyalty + non-loyalty), with POS net sales and gross margin.

with source as (
    select * from {{ source('pos', 'digital_checks') }}
)

select
    check_key,
    business_date,
    store_number,
    net_sales,
    gross_margin,
    (loyalty_flag = 'Y')         as is_loyalty
from source
