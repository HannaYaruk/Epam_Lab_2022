CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE country_regions_ext;

CREATE TABLE country_regions_ext (
    country_id     VARCHAR(256),
    country_desc   VARCHAR(256),
    structure_code VARCHAR(256),
    structure_desc VARCHAR(256)
);

DROP TABLE country_regions_load;

CREATE TABLE country_regions_load (
    country_id     VARCHAR(256),
    country_desc   VARCHAR(256),
    structure_code VARCHAR(256),
    structure_desc VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            country_id CHAR ( 256 ),
            country_desc CHAR ( 256 ),
            structure_code CHAR ( 256 ),
            structure_desc CHAR ( 256 )
        )
    ) LOCATION ( 'geo_countries_structure_iso3166.csv' )
);

INSERT INTO country_regions_ext (
    country_id,
    country_desc,
    structure_code,
    structure_desc
)
    ( SELECT
        country_id,
        country_desc,
        structure_code,
        structure_desc
    FROM
        country_regions_load
    );

COMMIT;

SELECT
    country_id,
    country_desc,
    structure_code,
    structure_desc
FROM
    country_regions_ext;

GRANT SELECT ON country_regions_ext TO bl_cl;