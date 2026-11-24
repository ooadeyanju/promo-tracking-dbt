-- Run in pgAdmin on the "digital" database (Query Tool > paste > Run). Clears earlier versions.
DROP SCHEMA IF EXISTS loyalty CASCADE;
DROP SCHEMA IF EXISTS pos CASCADE;
CREATE SCHEMA loyalty;
CREATE SCHEMA pos;

-- Loyalty platform (source 1)
CREATE TABLE loyalty.user_profile     (user_id text, signup_date date, home_store_id int);
CREATE TABLE loyalty.locations        (store_id int, store_number int);
CREATE TABLE loyalty.stores           (store_number int, state_province text, country text, region text, open_date date);
CREATE TABLE loyalty.check_in         (check_key bigint, user_id text, store_id int, checkin_ts timestamp,
                                       order_total numeric(10,2), status text);
CREATE TABLE loyalty.redeemables      (redeemable_id int, criterion_id int, redeemable_name text);
CREATE TABLE loyalty.offer_redemption (redemption_id int, check_key bigint, user_id text, redeemable_id int,
                                       redeemed_ts timestamp, discount_amount numeric(10,2));

-- POS / digital sales (source 2): every digital check (loyalty + non-loyalty) with sales and margin
CREATE TABLE pos.digital_checks            (check_key bigint, business_date date, store_number int,
                                            net_sales numeric(12,2), loyalty_flag text, gross_margin numeric(12,2));
CREATE TABLE pos.digital_check_redeemables (check_key bigint, redeemable_id int);

-- Check counts after importing. Expected: 8000, 40, 40, 87717, 24, 10328, 99846, 11561
SELECT 'user_profile' t, COUNT(*) FROM loyalty.user_profile
UNION ALL SELECT 'locations', COUNT(*) FROM loyalty.locations
UNION ALL SELECT 'stores', COUNT(*) FROM loyalty.stores
UNION ALL SELECT 'check_in', COUNT(*) FROM loyalty.check_in
UNION ALL SELECT 'redeemables', COUNT(*) FROM loyalty.redeemables
UNION ALL SELECT 'offer_redemption', COUNT(*) FROM loyalty.offer_redemption
UNION ALL SELECT 'digital_checks', COUNT(*) FROM pos.digital_checks
UNION ALL SELECT 'digital_check_redeemables', COUNT(*) FROM pos.digital_check_redeemables;
