-- DROP FUNCTION shp.kt_order_items(arg_shp_id integer);

CREATE OR REPLACE FUNCTION shp.kt_order_items(arg_shp_id integer, OUT oid character varying, OUT name character varying,
OUT price numeric,
OUT quantity numeric, OUT vat character varying, OUT measure_name character varying, OUT type character varying)
 RETURNS SETOF record
 LANGUAGE sql
AS $function$
SELECT (row_number() OVER())::varchar AS oid, name, price, quantity, vat, measure_name, type
FROM
(SELECT
b.dt_create,
bc."ПозицияСчета" as npp,
-- k.kt_name as name, --
bc."Наименование" as name,
bc."ЦенаНДС"::numeric as price,
bc."Кол-во"::numeric as quantity,
k.kt_vat as vat,
bc."Ед Изм" as measure_name,
k.kt_type AS type
FROM shp.ship_bills sb
JOIN "Содержание счета" bc ON sb.bill = bc."№ счета" -- AND bc."КодСодержания" <> 100008587
JOIN "Счета" b ON sb.bill = b."№ счета" AND shp.kt_valid_firm(b.фирма)
LEFT JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
-- JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
WHERE sb.shp_id=$1
ORDER BY dt_create, npp
) AS kt_items

$function$
;
