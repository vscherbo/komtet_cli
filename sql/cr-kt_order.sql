CREATE OR REPLACE FUNCTION shp.kt_order(
    arg_shp_id integer, -- shp.kt_q.shp_id OR komtet_id for DEL
    arg_operation varchar DEFAULT 'CREATE'
    )
  RETURNS character varying AS
$BODY$
DECLARE cmd character varying;
  args VARCHAR := '';
  ret_str VARCHAR := '';
  err_str VARCHAR := '';
  wrk_dir text := '/opt/komtet-cash';
BEGIN
    IF arg_operation = 'CREATE' THEN
        -- cmd := format('python3 %s/cre_order.py --pg_srv=localhost --log_file=%s/dl_add_ca_person.log --conf=%s --shp_id=%s', 
        cmd := format('python3 %s/cre_order.py --log_level=DEBUG --log_file=%s/cre_order.log --conf=%s --shp_id=%s', 
            wrk_dir, -- script dir
            wrk_dir, -- logfile dir
            format('%s/komtet.conf', wrk_dir), -- conf file
            arg_shp_id);
        -- --conf= ... --log_level=INFO
    ELSIF arg_operation = 'DEL' THEN 
        cmd := format('python3 %s/komtet.py delete-order %s', wrk_dir, arg_shp_id);
    ELSIF arg_operation = 'LIST' THEN 
        if arg_shp_id > 0 then 
            args := '--start=' || arg_shp_id::varchar;
            RAISE NOTICE 'args=%', args;
        end if;
        cmd := format('python3 %s/komtet.py get-orders %s', wrk_dir, args);
    END IF;

    IF cmd IS NULL 
    THEN 
       ret_str := 'cre_order cmd IS NULL';
       RAISE '%', ret_str ; 
    END IF;

    SELECT * FROM public.exec_shell(cmd) INTO ret_str, err_str ;

    IF err_str IS NOT NULL
    THEN 
       RAISE 'kt_order cmd=%^err_str=[%]', cmd, err_str; 
    END IF;

    /**
    IF (ret_str IS NULL) OR (ret_str = '')
    THEN 
       ret_str := 'OK';
    END IF;
    **/
    
    return ret_str;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
