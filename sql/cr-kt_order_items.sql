DROP FUNCTION shp.kt_order_items(arg_shp_id integer);

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
JOIN "Содержание счета" bc ON sb.bill = bc."№ счета" AND bc."КодСодержания" <> 100008587
JOIN "Счета" b ON sb.bill = b."№ счета" AND shp.kt_valid_firm(b.фирма)
LEFT JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
-- JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
WHERE sb.shp_id=$1
UNION ALL
SELECT
'9999-12-31', --last
1, -- Npp
c."Кратко",
c."Цена"::NUMERIC,
1::NUMERIC, -- quantity
'no'::varchar, -- VAT
(SELECT "ЕдИзм" FROM arc_energo."ОКЕИ" ok WHERE ok."КодОКЕИ" = c."ОКЕИ"),
'service'::varchar
FROM "Содержание" c
WHERE c."КодСодержания" = 100008587
ORDER BY dt_create, npp
) AS kt_items

/**************
declare
begin
RETURN QUERY
SELECT
bc."ПозицияСчета"::varchar as oid
, bc."Наименование" as name
, bc."ЦенаНДС"::numeric as price
, bc."Кол-во"::numeric as quantity
, k.kt_vat as vat
, bc."Ед Изм" as measure_name
, k.kt_type AS type
FROM shp.ship_bills sb
JOIN "Содержание счета" bc ON sb.bill = bc."№ счета"
JOIN "Счета" b ON sb.bill = b."№ счета" AND b.фирма = 'ИПБ'
LEFT JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
WHERE sb.shp_id=arg_shp_id
ORDER BY oid;
-- SELECT oid, name, price, quantity, vat, measure_name, type FROM items i
IF NOT FOUND THEN
    RETURN QUERY
        SELECT
            '1'::varchar
            , 'Организация доставки'::varchar
            , q.delivery_cost
            , 1::NUMERIC
            , '0'::varchar
            , 'шт'::varchar
            , 'service'::varchar
        FROM kt_q q WHERE q.shp_id = arg_shp_id AND q.delivery_cost IS NOT NULL;
END IF;
RETURN;
end;
**************/

$function$
;
