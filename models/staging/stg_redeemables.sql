-- One row per redeemable. The PLU is the number in the LAST brackets of the name,
-- e.g. '$3 Off $15 (APP ONLY) (4712)' -> 4712. Some names have two sets of brackets.

with source as (
    select * from {{ source('loyalty', 'redeemables') }}
)

select
    redeemable_id,
    criterion_id,
    redeemable_name                                                   as redeemable_name_raw,
    (regexp_match(redeemable_name, '\((\d+)\)\s*$'))[1]::int          as plu_id,
    trim(regexp_replace(
        replace(regexp_replace(redeemable_name, '\s*\(\d+\)\s*$', ''), '_', ' '),
        '\s+', ' ', 'g'))                                             as redeemable_name
from source
