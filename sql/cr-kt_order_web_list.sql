/***
drop type shp.kt_order_ret cascade;
create type shp.kt_order_ret as (
    amount numeric,
    callback_url varchar,
    client_address text,
    client_email text,
    client_name text,
    client_phone text,
    courier varchar,
    date_end text,
    date_start text,
    description text,
    external_id text,
    id text, -- integer,
    is_paid boolean,
    is_pay_to_courier boolean,
    payment_type text,
    prepayment numeric,
    sno integer,
    state text
);
***/


-- drop FUNCTION shp.kt_order_web_list();
CREATE OR REPLACE FUNCTION shp.kt_order_web_list(arg_start integer DEFAULT -1)
 RETURNS setof kt_order_ret
 LANGUAGE plpgsql
AS $function$
BEGIN
    return query        
            SELECT (row1::jsonb->>'amount')::numeric,
            (row1::jsonb->>'callback_url')::varchar,
            row1::jsonb->>'client_address',
            row1::jsonb->>'client_email',
            row1::jsonb->>'client_name',
            row1::jsonb->>'client_phone',
            (row1::jsonb->>'courier')::varchar,
            row1::jsonb->>'date_end',
            row1::jsonb->>'date_start',
            row1::jsonb->>'description',
            row1::jsonb->>'external_id',
            row1::jsonb->>'id', -- ::integer,
            (row1::jsonb->>'is_paid')::boolean,
            (row1::jsonb->>'is_pay_to_courier')::boolean,
            row1::jsonb->>'payment_type',
            (row1::jsonb->>'prepayment')::numeric,
            (row1::jsonb->>'sno')::integer,
            row1::jsonb->>'state'
           -- row1::jsonb AS rec_j
            FROM
                (SELECT regexp_split_to_table(kt_order, '\n') AS row1 FROM shp.kt_order(arg_start, 'LIST')) AS kto
            WHERE row1 <> ''; -- последняя строка пустая, не м.б. jsonb

    RETURN;
END;
$function$
;
