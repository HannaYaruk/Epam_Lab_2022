CREATE OR REPLACE DIRECTORY ext_tab_dir AS '/opt/oracle/oradata';

DROP TABLE paym_type_belg_ext;

CREATE TABLE paym_type_belg_ext (
    id_paym_type VARCHAR(256),
    paym_type    VARCHAR(256),
    paym_acc     VARCHAR(256)
);

DROP TABLE paym_type_b_load;

CREATE TABLE paym_type_b_load (
    id_paym_type VARCHAR(256),
    paym_type    VARCHAR(256),
    paym_acc     VARCHAR(256)
)
ORGANIZATION EXTERNAL ( TYPE oracle_loader
    DEFAULT DIRECTORY ext_tab_dir ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            SKIP 1
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL REJECT ROWS WITH ALL NULL FIELDS (
            id_paym_type CHAR ( 256 ),
            paym_type CHAR ( 256 ),
            paym_acc CHAR ( 256 )
        )
    ) LOCATION ( 'payment_type_bel.csv' )
);

INSERT INTO paym_type_belg_ext (
    id_paym_type,
    paym_type,
    paym_acc
)
    ( SELECT
        id_paym_type,
        paym_type,
        paym_acc
    FROM
        paym_type_b_load
    );

COMMIT;

SELECT
    id_paym_type,
    paym_type,
    paym_acc
FROM
    paym_type_belg_ext;

GRANT SELECT ON paym_type_belg_ext TO bl_cl;