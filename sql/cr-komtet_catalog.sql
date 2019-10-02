-- Drop table

-- DROP TABLE cash.komtet_catalog;
/**
Требования к загружаемому файлу:
загружаемый файл должен иметь формат xlsx-таблицы;
первая строка таблицы должна содержать заголовки;
заголовки должны быть все и в указанном порядке: 
Категория, Наименование, ID внешней системы, Артикул, Единица измерения, Цена, Штрих-код EAN13, Описание, НДС, Архивный, Тип;
поле товара, обязательное для заполнения - Наименование;
поле "НДС" может иметь значения: no, 0, 10, 18, 110, 118;
поле "Тип" может иметь значения: product, service;
при отсутствии значения оставлять ячейку пустой (без прочерков, пробелов и т.д.);

**/

CREATE TABLE cash.komtet_catalog (
    kt_category varchar NULL,
    kt_name varchar NOT NULL,
    kt_code int4 NOT NULL,
    kt_articul varchar NULL,
    kt_measure_unit varchar NULL,
    kt_price numeric NOT NULL DEFAULT 0.00,
    kt_ean13 varchar NULL,
    kt_descr varchar NULL,
    kt_vat varchar NOT NULL DEFAULT 'no'::character varying,
    kt_archive varchar NULL,
    kt_type varchar NOT NULL DEFAULT 'product'::character varying,
    CONSTRAINT komtet_catalog_pk PRIMARY KEY (kt_code)
);

-- Permissions
ALTER TABLE cash.komtet_catalog OWNER TO arc_energo;
GRANT ALL ON TABLE cash.komtet_catalog TO arc_energo;
