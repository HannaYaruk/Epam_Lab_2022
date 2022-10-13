CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE discounts_ext;

CREATE TABLE discounts_ext (
    id_disc    VARCHAR(256),
    title      VARCHAR(256),
    percentage VARCHAR(256)
);

DROP TABLE discounts_b_load;

CREATE TABLE discounts_b_load (
    id_disc    VARCHAR(256),
    title      VARCHAR(256),
    percentage VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            id_disc CHAR ( 256 ),
            title CHAR ( 256 ),
            percentage CHAR ( 256 )
        )
    ) LOCATION ( 'discounts.csv' )
);

INSERT INTO discounts_ext (
    id_disc,
    title,
    percentage
)
    ( SELECT
        id_disc,
        title,
        percentage
    FROM
        discounts_b_load
    );

COMMIT;

SELECT
    id_disc,
    title,
    percentage
FROM
    discounts_ext;

GRANT SELECT ON discounts_ext TO bl_cl;