CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE prod_fra_ext;

CREATE TABLE prod_fra_ext (
    product_id             VARCHAR(256),
    product_name           VARCHAR(256),
    product_desc           VARCHAR(256),
    category_name          VARCHAR(256),
    product_cost           VARCHAR(256),
    product_price          VARCHAR(256),
    warehouse_id           VARCHAR(256),
    warehouse_name         VARCHAR(256),
    warehouse_address      VARCHAR(256),
    warehouse_city         VARCHAR(256),
    warehouse_country_code VARCHAR(256),
    warehouse_country_name VARCHAR(256),
    warehouse_postal_code  VARCHAR(256),
    warehouse_phone        VARCHAR(256),
    total                  VARCHAR(256)
);

DROP TABLE prod_fra_load;

CREATE TABLE prod_fra_b_load (
    product_id             VARCHAR(256),
    product_name           VARCHAR(256),
    product_desc           VARCHAR(256),
    category_name          VARCHAR(256),
    product_cost           VARCHAR(256),
    product_price          VARCHAR(256),
    warehouse_id           VARCHAR(256),
    warehouse_name         VARCHAR(256),
    warehouse_address      VARCHAR(256),
    warehouse_city         VARCHAR(256),
    warehouse_country_code VARCHAR(256),
    warehouse_country_name VARCHAR(256),
    warehouse_postal_code  VARCHAR(256),
    warehouse_phone        VARCHAR(256),
    total                  VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            product_id CHAR ( 256 ),
            product_name CHAR ( 256 ),
            product_desc CHAR ( 256 ),
            category_name CHAR ( 256 ),
            product_cost CHAR ( 256 ),
            product_price CHAR ( 256 ),
            warehouse_id CHAR ( 256 ),
            warehouse_name CHAR ( 256 ),
            warehouse_address CHAR ( 256 ),
            warehouse_city CHAR ( 256 ),
            warehouse_country_code CHAR ( 256 ),
            warehouse_country_name CHAR ( 256 ),
            warehouse_postal_code CHAR ( 256 ),
            warehouse_phone CHAR ( 256 ),
            total CHAR ( 256 )
        )
    ) LOCATION ( 'product_fra.csv' )
);

INSERT INTO prod_fra_ext (
    product_id,
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
    total
)
    ( SELECT
        product_id,
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
        total
    FROM
        prod_fra_b_load
    );

COMMIT;

SELECT
    product_id,
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
    total
FROM
    prod_fra_ext;

GRANT SELECT ON prod_fra_ext TO bl_cl;