drop TABLE payment_fra_src;
CREATE TABLE payment_fra_src (
    payment_id VARCHAR(256)
    , product_id VARCHAR(256)
    , customer_id VARCHAR(256)
    , employee_id VARCHAR(256)
    , warehouse_id VARCHAR(256)
    , payment_type_id VARCHAR(256)
    , discount_id VARCHAR(256)
    , quantity VARCHAR(256)
    , sale_date VARCHAR(256)
    , update_dt DATE);


INSERT INTO payment_fra_src
SELECT payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , current_date
FROM payment_fra_ext;

COMMIT;

SELECT payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , update_dt
FROM payment_fra_src;
