CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE cust_fra_ext;

CREATE TABLE cust_fra_ext (
    id_cust      VARCHAR(256),
    personal_id  VARCHAR(256),
    first_name   VARCHAR(256),
    last_name    VARCHAR(256),
    email        VARCHAR(256),
    address      VARCHAR(256),
    city         VARCHAR(256),
    country_code VARCHAR(256),
    country_name VARCHAR(256),
    postal_code  VARCHAR(256),
    phone        VARCHAR(256)
);

DROP TABLE cust_b_load;

CREATE TABLE cust_b_load (
    id_cust      VARCHAR(256),
    personal_id  VARCHAR(256),
    first_name   VARCHAR(256),
    last_name    VARCHAR(256),
    email        VARCHAR(256),
    address      VARCHAR(256),
    city         VARCHAR(256),
    country_code VARCHAR(256),
    country_name VARCHAR(256),
    postal_code  VARCHAR(256),
    phone        VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            id_cust CHAR ( 256 ),
            personal_id CHAR ( 256 ),
            first_name CHAR ( 256 ),
            last_name CHAR ( 256 ),
            email CHAR ( 256 ),
            address CHAR ( 256 ),
            city CHAR ( 256 ),
            country_code CHAR ( 256 ),
            country_name CHAR ( 256 ),
            postal_code CHAR ( 256 ),
            phone CHAR ( 256 )
        )
    ) LOCATION ( 'customer_fra.csv' )
);

INSERT INTO cust_fra_ext (
    id_cust,
    personal_id,
    first_name,
    last_name,
    email,
    address,
    city,
    country_code,
    country_name,
    postal_code,
    phone
)
    ( SELECT
        id_cust,
        personal_id,
        first_name,
        last_name,
        email,
        address,
        city,
        country_code,
        country_name,
        postal_code,
        phone
    FROM
        cust_b_load
    );

COMMIT;

SELECT
    id_cust,
    personal_id,
    first_name,
    last_name,
    email,
    address,
    city,
    country_code,
    country_name,
    postal_code,
    phone
FROM
    cust_fra_ext;

GRANT SELECT ON cust_fra_ext TO bl_cl;