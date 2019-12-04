CREATE OR REPLACE FUNCTION shp.kt_order_web_status(arg_shp_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
--  0 status is the same
--  1 status updated in kt_q
-- -1 NOT found in kt_q
-- -2 found in kt_q, but not found in kt_orders
DECLARE 
rc integer;
res jsonb;
kt_q_rec record;
BEGIN
    SELECT * INTO kt_q_rec FROM shp.kt_q WHERE shp_id = arg_shp_id;
    IF FOUND THEN
        SELECT rec_j INTO res FROM (
            SELECT (row1::jsonb->>'external_id')::integer kt_shp_id, row1::jsonb AS rec_j
            FROM
                (SELECT regexp_split_to_table(kt_order, '\n') AS row1 FROM shp.kt_order(-1, 'LIST')) AS kto
            WHERE row1 <> '') AS kt_j -- последняя строка пустая, не м.б. jsonb
        WHERE kt_shp_id = arg_shp_id;
        IF NOT FOUND THEN
            rc := -2; -- found in kt_q, but not found in kt_orders
        ELSE
            RAISE NOTICE 'res=%', res->>'state';
            IF kt_q_rec.state = res->>'state' THEN -- return 0, i.e. the same
                rc := 0;
            ELSE -- update kt_q
                UPDATE shp.kt_q SET state = res->>'state' WHERE shp_id = arg_shp_id;
                IF FOUND THEN rc := 1; END IF;
            END IF;
        END IF;
    ELSE
        rc := -1; -- NOT found in kt_q
    END IF;
    RETURN rc;
END;
$function$
;
