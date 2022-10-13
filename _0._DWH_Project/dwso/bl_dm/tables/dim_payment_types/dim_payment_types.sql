--drop TABLE dim_payment_types;
CREATE TABLE dim_payment_types (
    payment_type_dm_surr_id NUMBER NOT NULL,
    payment_type_id      NUMBER NOT NULL,
    source_system        VARCHAR2(256) NOT NULL,
    source_entity        VARCHAR2(256) NOT NULL,
    payment_type         VARCHAR2(256)NOT NULL,
    payment_account      VARCHAR2(256) NOT NULL,
    update_dt            DATE NOT NULL
);

ALTER TABLE dim_payment_types ADD CONSTRAINT dim_payment_types_pk PRIMARY KEY ( payment_type_dm_surr_id );
GRANT SELECT, INSERT, UPDATE ON dim_payment_types TO BL_CL;