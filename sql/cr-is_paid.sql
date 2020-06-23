CREATE OR REPLACE FUNCTION shp.is_paid(shp.kt_q)
 RETURNS boolean
 LANGUAGE sql
AS $function$
WITH bills AS (SELECT sb.bill FROM shp.ship_bills sb WHERE $1.shp_id = sb.shp_id)
    -- SELECT SUM(COALESCE(b."Сумма1", 0)) + $1.delivery_cost = COALESCE(SUM(COALESCE(b."Оплата1", 0)), 0) as RESULT FROM "Счета" b 
    SELECT SUM(COALESCE(b."Сумма1", 0)) = COALESCE(SUM(COALESCE(b."Оплата1", 0)), 0) as RESULT FROM "Счета" b 
    WHERE b."№ счета" IN (SELECT bill FROM bills);    
    
$function$
;

