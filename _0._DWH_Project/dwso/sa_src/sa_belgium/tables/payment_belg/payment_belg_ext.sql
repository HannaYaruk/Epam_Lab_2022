CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE payment_belg_ext;

CREATE TABLE payment_belg_ext (
    payment_id      VARCHAR(256),
    product_id      VARCHAR(256),
    customer_id     VARCHAR(256),
    employee_id     VARCHAR(256),
    warehouse_id    VARCHAR(256),
    payment_type_id VARCHAR(256),
    discount_id     VARCHAR(256),
    quantity        VARCHAR(256),
    sale_date       VARCHAR(256)
);

DROP TABLE payment_b_load;

CREATE TABLE payment_b_load (
    payment_id      VARCHAR(256),
    product_id      VARCHAR(256),
    customer_id     VARCHAR(256),
    employee_id     VARCHAR(256),
    warehouse_id    VARCHAR(256),
    payment_type_id VARCHAR(256),
    discount_id     VARCHAR(256),
    quantity        VARCHAR(256),
    sale_date       VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            payment_id CHAR ( 256 ),
            product_id CHAR ( 256 ),
            customer_id CHAR ( 256 ),
            employee_id CHAR ( 256 ),
            warehouse_id CHAR ( 256 ),
            payment_type_id CHAR ( 256 ),
            discount_id CHAR ( 256 ),
            quantity CHAR ( 256 ),
            sale_date CHAR ( 256 )
        )
    ) LOCATION ( 'payments_bel.csv' )
);

INSERT INTO payment_belg_ext (
    payment_id,
    product_id,
    customer_id,
    employee_id,
    warehouse_id,
    payment_type_id,
    discount_id,
    quantity,
    sale_date
)
    ( SELECT
        payment_id,
        product_id,
        customer_id,
        employee_id,
        warehouse_id,
        payment_type_id,
        discount_id,
        quantity,
        sale_date
    FROM
        payment_b_load
    );

COMMIT;

SELECT
    payment_id,
    product_id,
    customer_id,
    employee_id,
    warehouse_id,
    payment_type_id,
    discount_id,
    quantity,
    sale_date
FROM
    payment_belg_ext;

GRANT SELECT ON payment_belg_ext TO bl_cl;