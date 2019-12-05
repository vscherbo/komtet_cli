DROP FUNCTION shp.kt_order_items(integer);

CREATE OR REPLACE FUNCTION shp.kt_order_items(arg_shp_id integer,
    /**/
    OUT oid varchar,
    OUT name varchar,
    OUT price float,
    OUT quantity float,
    OUT vat varchar,
    OUT measure_name varchar,
    OUT type varchar)
/**/
 RETURNS SETOF RECORD
 LANGUAGE sql
AS $function$
/**
*external_id - позиция в заказе
 type - product OR service
*name
*price
*quantity
*total
*vat
 measure_name
**/

WITH items AS (
SELECT
bc."ПозицияСчета"::varchar as oid
, bc."Наименование" as name
, bc."ЦенаНДС"::float as price
, bc."Кол-во"::float as quantity
, k.kt_vat as vat
, bc."Ед Изм" as measure_name
, k.kt_type AS type
FROM shp.ship_bills b
JOIN "Содержание счета" bc ON b.bill = bc."№ счета" 
LEFT JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
WHERE b.shp_id=arg_shp_id)
, max_item AS (SELECT * FROM items ORDER BY oid DESC LIMIT 1)
SELECT i.* FROM items i
UNION
(SELECT (m.oid::int4+1)::varchar, 'Организация доставки', q.delivery_cost, 1, m.vat, 'шт', 'service' FROM max_item m
JOIN kt_q q ON q.shp_id = arg_shp_id AND q.delivery_cost IS NOT NULL)
ORDER BY oid;

$function$
;
