drop TABLE wareh_fra_src;
CREATE TABLE wareh_fra_src (
     warehouse_id VARCHAR(256),
     warehouse_name VARCHAR(256),
     warehouse_address    VARCHAR(256),
     warehouse_city    VARCHAR(256),
     warehouse_country_code VARCHAR(256),
     warehouse_country_name      VARCHAR(256),
     warehouse_postal_code    VARCHAR(256),
     warehouse_phone      VARCHAR(256),
     total    VARCHAR(256),
     update_dt DATE
     );

INSERT INTO wareh_fra_src
SELECT warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total
FROM wareh_fra_ext;

COMMIT;

SELECT warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total
FROM wareh_fra_src;
