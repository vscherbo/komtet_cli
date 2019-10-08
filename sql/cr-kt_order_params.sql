CREATE OR REPLACE FUNCTION shp.kt_order_params(arg_bill_no integer)
 RETURNS kt_order
 LANGUAGE plpgsql
AS $function$
DECLARE
    res kt_order;
BEGIN 
    /**
    res.external_id := arg_bill_no;
    res.client_name :=  ;
   *res.client_address :=  ;
   *res.client_phone :=  ;
    res.client_email :=  ;
    res.is_paid :=  ;
    res.description :=  ;
    res.state :=  ;
   *res.date_start :=  ;
   *res.date_end :=  ;
    res.sno :=  ;
    res.courier_id integer,
    res.prepayment :=  ;
    res.payment_type :=  ;
**/

SELECT 
arg_bill_no,
e."ФИО",
e."Примечание", -- 'СПБ, Адрес',
e."Телефон",
e."ЕАдрес",
b.Сумма = b.Сумма1 AS is_paid,
q.description,
q.status,
to_char(now(), 'YYYY-MM-DD HH:MI'),
to_char(now()+'1 day', 'YYYY-MM-DD HH:MI'),
1, -- СНО доход
q.courier_id,
NULL, -- prepayment
q.payment_type
INTO res
FROM "Счета" b
JOIN shp.kt_q q ON b."№ счета" = q.bill_no AND b."ОтгрузкаКем" = 'Курьером по СПб' AND b."ОтгрузкаОплата" = 'Они'
JOIN "Работники" e ON e."КодРаботника" = b."КодРаботника" -- AND b."Код" = 223719
WHERE b."№ счета" = arg_bill_no;
RETURN res;
END
$function$
;
