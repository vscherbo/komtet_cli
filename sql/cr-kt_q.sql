-- Drop table

-- DROP TABLE shp.kt_q cascade;

CREATE TABLE shp.kt_q (
    id serial NOT NULL,
    shp_id int4 NOT NULL DEFAULT -1,
    state varchar NOT NULL DEFAULT 'new'::character varying, -- new - новый, done - выполнен, canceled - отменен
    cli_name varchar NULL,
    cli_address varchar NOT NULL,
    cli_phone varchar NOT NULL,
    cli_email varchar NULL,
    dt_start timestamp NOT NULL,
    dt_end timestamp NOT NULL,
    payment_type varchar NOT NULL DEFAULT 'card'::character varying, -- card - оплата безналичными (по умолчанию), cash - оплата наличными, prepayment - сумма предоплатой (зачет аванса и/или предыдущих платежей), credit - сумма постоплатой (кредит), counter_provisioning - сумма встречным предоставлением
    sno int4 NOT NULL DEFAULT 1, -- 1 - УСН доход
    courier_id int4 NOT NULL DEFAULT 386, -- от КОМТЕТ
    prepayment numeric NULL,
    description varchar NULL,
    delivery_cost numeric NULL,
    id_komtet int4 NULL,
    stts int4 NOT NULL DEFAULT 0,
    CONSTRAINT kt_q_pk PRIMARY KEY (id)
);
COMMENT ON TABLE shp.kt_q IS 'очередь доставок курьером для КОМТЕТ';

-- Column comments

COMMENT ON COLUMN shp.kt_q.state IS 'new - новый, done - выполнен, canceled - отменен';
COMMENT ON COLUMN shp.kt_q.payment_type IS 'card - оплата безналичными (по умолчанию), cash - оплата наличными, prepayment - сумма предоплатой (зачет аванса и/или предыдущих платежей), credit - сумма постоплатой (кредит), counter_provisioning - сумма встречным предоставлением';
COMMENT ON COLUMN shp.kt_q.sno IS '1 - УСН доход';
COMMENT ON COLUMN shp.kt_q.courier_id IS 'от КОМТЕТ';
COMMENT ON COLUMN shp.kt_q.stts IS '0 - создан, 10 - создан в Комтет, 20 - взят курьером, 30 - отдан курьером, 31 - отменён, 90 - завершён, деньги в кассе';

-- Permissions

ALTER TABLE shp.kt_q OWNER TO arc_energo;
GRANT ALL ON TABLE shp.kt_q TO arc_energo;

