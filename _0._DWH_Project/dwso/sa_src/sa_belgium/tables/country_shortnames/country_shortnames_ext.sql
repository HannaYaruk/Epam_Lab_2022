CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE country_shortnames_ext;

CREATE TABLE country_shortnames_ext (
    country_id   VARCHAR(10),
    country_desc VARCHAR(256),
    country_code VARCHAR(256)
);

COMMIT;

DROP TABLE country_shortnames_ext_load;

CREATE TABLE country_shortnames_ext_load (
    country_id   VARCHAR(10),
    country_desc VARCHAR(256),
    country_code VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' (
            country_id CHAR ( 10 ),
            country_desc CHAR ( 256 ),
            country_code CHAR ( 256 )
        )
    ) LOCATION ( 'geo_countries_iso3166.csv' )
);

INSERT INTO country_shortnames_ext (
    country_id,
    country_desc,
    country_code
)
    ( SELECT
        country_id,
        country_desc,
        country_code
    FROM
        country_shortnames_ext_load
    );

COMMIT;

SELECT
    country_id,
    TRIM(country_desc),
    TRIM(country_code)
FROM
    country_shortnames_ext;

GRANT SELECT ON country_shortnames_ext TO bl_cl;