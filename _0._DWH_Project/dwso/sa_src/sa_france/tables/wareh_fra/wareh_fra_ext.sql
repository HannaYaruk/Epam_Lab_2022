CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE wareh_fra_ext;

CREATE TABLE wareh_fra_ext (
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

DROP TABLE wareh_fra_b_load;

CREATE TABLE wareh_fra_b_load (
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
    ) LOCATION ( 'warehouse_fra.csv' )
);

INSERT INTO wareh_fra_ext (
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
        wareh_fra_b_load
    );

COMMIT;

SELECT
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
    wareh_fra_ext;

GRANT SELECT ON wareh_fra_ext TO bl_cl;