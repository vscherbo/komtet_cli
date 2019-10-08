drop type shp.kt_order cascade;
create type shp.kt_order as (
    external_id text,
    client_name text,
    client_address text,
    client_phone text,
    client_email text,
    is_paid boolean,
    description text,
    state text,
    date_start text,
    date_end text,
    sno integer,
    courier_id integer,
    prepayment numeric,
    payment_type text
);
