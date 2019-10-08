-- Drop table
--DROP TABLE shp.kt_q;

CREATE TABLE shp.kt_q (
	id serial NOT NULL,
	bill_no int4 NOT NULL,
	status varchar NOT NULL DEFAULT 'new'::character varying, -- new - новый, done - выполнен, canceled - отменен
	dt_start timestamp NULL,
	dt_end timestamp NULL,
	payment_type varchar NULL DEFAULT 'card'::character varying, -- card - оплата безналичными (по умолчанию), cash - оплата наличными, prepayment - сумма предоплатой (зачет аванса и/или предыдущих платежей), credit - сумма постоплатой (кредит), counter_provisioning - сумма встречным предоставлением
	id_courier int4 NOT NULL,
	description varchar NULL,
	id_komtet int4 NULL
);
COMMENT ON TABLE shp.kt_q IS 'очередь доставок курьером для КОМТЕТ';

-- Column comments

COMMENT ON COLUMN shp.kt_q.status IS 'new - новый, done - выполнен, canceled - отменен';
COMMENT ON COLUMN shp.kt_q.payment_type IS 'card - оплата безналичными (по умолчанию), cash - оплата наличными, prepayment - сумма предоплатой (зачет аванса и/или предыдущих платежей), credit - сумма постоплатой (кредит), counter_provisioning - сумма встречным предоставлением';

-- Permissions

ALTER TABLE shp.kt_q OWNER TO arc_energo;
GRANT ALL ON TABLE shp.kt_q TO arc_energo;
