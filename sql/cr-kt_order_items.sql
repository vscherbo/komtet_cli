DROP FUNCTION shp.kt_order_items(integer);

CREATE OR REPLACE FUNCTION shp.kt_order_items(arg_bill_no integer,
    /**/
    OUT oid integer,
    OUT name varchar,
    OUT price numeric,
    OUT quantity numeric,
    OUT vat varchar,
    OUT measure_name varchar)
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

SELECT
bc."ПозицияСчета" as oid
, bc."Наименование" as name
, bc."ЦенаНДС" as price
, bc."Кол-во"::numeric as quantity
, NULL::varchar as vat
, bc."Ед Изм" as measure_name
FROM "Содержание счета" bc
WHERE bc."№ счета" = arg_bill_no
ORDER BY bc."ПозицияСчета";
$function$
;
