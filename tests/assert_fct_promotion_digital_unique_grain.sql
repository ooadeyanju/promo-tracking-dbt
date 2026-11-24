-- Fails if any date + store + promo + redeemable combination appears more than once
select business_date, store_number, promo_id, redeemable_id, count(*) as row_count
from {{ ref('fct_promotion_digital') }}
group by 1, 2, 3, 4
having count(*) > 1