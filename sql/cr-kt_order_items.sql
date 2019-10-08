DROP FUNCTION shp.kt_order_items(integer);

CREATE OR REPLACE FUNCTION shp.kt_order_items(arg_bill_no integer,
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

SELECT
bc."ПозицияСчета"::varchar as oid
, bc."Наименование" as name
, bc."ЦенаНДС"::float as price
, bc."Кол-во"::float as quantity
, k.kt_vat as vat                                                                    
, bc."Ед Изм" as measure_name
, k.kt_type AS type
FROM "Содержание счета" bc  
LEFT JOIN cash.komtet_catalog k ON k.kt_code = bc."КодСодержания"
WHERE bc."№ счета" = arg_bill_no
ORDER BY bc."ПозицияСчета";
$function$
;
