drop type shp.kt_order;
create type shp.kt_order as (
    external_id text,
    client_name text,
    client_address text,
    client_phone text,
    client_email text,
    is_paid text,
    description text,
    state text,
    date_start text,
    date_end text,
    sno text,
    courier_id integer,
    prepayment text,
    payment_type text
);
