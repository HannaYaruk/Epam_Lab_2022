CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE emp_belg_ext;

CREATE TABLE emp_belg_ext (
    id_emp       VARCHAR(256),
    personal_id  VARCHAR(256),
    first_name   VARCHAR(256),
    last_name    VARCHAR(256),
    email        VARCHAR(256),
    address      VARCHAR(256),
    city         VARCHAR(256),
    country_code VARCHAR(256),
    country_name VARCHAR(256),
    postal_code  VARCHAR(256),
    phone        VARCHAR(256),
    emp_type     VARCHAR(256),
    start_dt     VARCHAR(256),
    end_dt       VARCHAR(256),
    curr_flag    VARCHAR(256)
);

DROP TABLE emp_b_load;

CREATE TABLE emp_b_load (
    id_emp       VARCHAR(256),
    personal_id  VARCHAR(256),
    first_name   VARCHAR(256),
    last_name    VARCHAR(256),
    email        VARCHAR(256),
    address      VARCHAR(256),
    city         VARCHAR(256),
    country_code VARCHAR(256),
    country_name VARCHAR(256),
    postal_code  VARCHAR(256),
    phone        VARCHAR(256),
    emp_type     VARCHAR(256),
    start_dt     VARCHAR(256),
    end_dt       VARCHAR(256),
    curr_flag    VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            id_emp CHAR ( 256 ),
            personal_id CHAR ( 256 ),
            first_name CHAR ( 256 ),
            last_name CHAR ( 256 ),
            email CHAR ( 256 ),
            address CHAR ( 256 ),
            city CHAR ( 256 ),
            country_code CHAR ( 256 ),
            country_name CHAR ( 256 ),
            postal_code CHAR ( 256 ),
            phone CHAR ( 256 ),
            emp_type CHAR ( 256 ),
            start_dt CHAR ( 256 ),
            end_dt CHAR ( 256 ),
            curr_flag CHAR ( 256 )
        )
    ) LOCATION ( 'employee_bel.csv' )
);

INSERT INTO emp_belg_ext (
    id_emp,
    personal_id,
    first_name,
    last_name,
    email,
    address,
    city,
    country_code,
    country_name,
    postal_code,
    phone,
    emp_type,
    start_dt,
    end_dt,
    curr_flag
)
    ( SELECT
        id_emp,
        personal_id,
        first_name,
        last_name,
        email,
        address,
        city,
        country_code,
        country_name,
        postal_code,
        phone,
        emp_type,
        start_dt,
        end_dt,
        curr_flag
    FROM
        emp_b_load
    );

COMMIT;

SELECT
    id_emp,
    personal_id,
    first_name,
    last_name,
    email,
    address,
    city,
    country_code,
    country_name,
    postal_code,
    phone,
    emp_type,
    start_dt,
    end_dt,
    curr_flag
FROM
    emp_belg_ext;

GRANT SELECT ON emp_belg_ext TO bl_cl;