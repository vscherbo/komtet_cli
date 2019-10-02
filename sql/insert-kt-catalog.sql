truncate table cash.komtet_catalog;

WITH arc2kt AS (SELECT 
k."Категория" kat, 
c."КодСодержания" ks,                                      
c."КодНаименования" kn
, substring(                                                                     
            format('%s %s',                                                      
                    c."КодСодержания", regexp_replace("НазваниевСчет", '\n', ' ', 'g')
                  )                                                              
            from 1 for 128) kt_name                                              
, p."ОтпускнаяЦена"::numeric kt_price                                            
FROM "Содержание" c
JOIN "Наименование" n ON n."КодНаименования" = c."КодНаименования" 
JOIN "Категория" k ON n."КодКатегории" = k."КодКатегории" 
join "vwЦены" p on p."КодСодержания" = c."КодСодержания"                         
where "Активность"                                                               
ORDER BY c."КодСодержания"                                                       
-- limit 10                                                                      
)                                                                                
INSERT INTO cash.komtet_catalog(kt_category, kt_name, kt_code, kt_articul, kt_price, kt_ean13, kt_descr, kt_vat, kt_archive, kt_type) (
SELECT
kat AS "Категория", kt_name AS "Наименование", ks AS "ID внешней системы", ks AS "Артикул", kt_price AS "Цена",
ks  AS "Штрих-код EAN13", '' AS "Описание", 'no' AS "НДС", '' AS "Архивный",
(CASE WHEN kn=100102 THEN 'service' ELSE 'product' END) AS "Тип"
FROM arc2kt
);             
