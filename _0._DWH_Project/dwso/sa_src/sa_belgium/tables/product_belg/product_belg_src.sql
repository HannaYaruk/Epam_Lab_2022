drop TABLE prod_belg_src;
CREATE TABLE prod_belg_src (
     product_id VARCHAR(256),
     product_name    VARCHAR(256),
     product_desc    VARCHAR(256),
     category_name VARCHAR(256),
     product_cost      VARCHAR(256),
     product_price    VARCHAR(256),
     warehouse_id    VARCHAR(256),
     warehouse_name VARCHAR(256),
     warehouse_address      VARCHAR(256),
     warehouse_city    VARCHAR(256),
     warehouse_country_code    VARCHAR(256),
     warehouse_country_name    VARCHAR(256),
     warehouse_postal_code VARCHAR(256),
     warehouse_phone      VARCHAR(256),
     total    VARCHAR(256),
     update_dt DATE
     );

INSERT INTO prod_belg_src
SELECT product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     current_date
FROM prod_belg_ext;

COMMIT;

SELECT product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     update_dt
FROM prod_belg_src;
