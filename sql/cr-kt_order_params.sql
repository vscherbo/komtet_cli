-- DROP FUNCTION shp.kt_order_params(arg_shp_id integer);


CREATE OR REPLACE FUNCTION shp.kt_order_params(arg_shp_id integer)
 RETURNS kt_order
 LANGUAGE plpgsql
AS $function$
DECLARE
    res kt_order;
BEGIN 
    /**
    res.external_id := arg_shp_id;
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
arg_shp_id,
q.cli_name,
q.cli_address,
q.cli_phone,
q.cli_email,
q.is_paid,
q.description,
q.status,
-- q.dt_start,
-- q.dt_end,
to_char(q.dt_start, 'YYYY-MM-DD HH24:MI') as date_start,                   
to_char(q.dt_end, 'YYYY-MM-DD HH24:MI') as date_end,                       
q.sno, -- 1 УСН доход
q.courier_id,
q.prepayment,
q.payment_type
INTO res
FROM shp.kt_q q
WHERE q.shp_id = arg_shp_id;

RETURN res;
END
$function$
;
