--drop TABLE dim_employees_scd
CREATE TABLE dim_employees_scd (
    employee_dm_surr_id NUMBER NOT NULL,
    employee_id      NUMBER NOT NULL,
    source_system    VARCHAR2(256) NOT NULL,
    source_entity    VARCHAR2(256) NOT NULL,
    personal_id      VARCHAR2(256) NOT NULL,
    first_name       VARCHAR2(256) NOT NULL,
    last_name        VARCHAR2(256) NOT NULL,
    email            VARCHAR2(256) NOT NULL,
    address_id       NUMBER NOT NULL,
    address          VARCHAR2(256) NOT NULL,
    city_id          NUMBER NOT NULL,
    city             VARCHAR2(256) NOT NULL,
    country_id       NUMBER NOT NULL,
    country_code     VARCHAR2(256) NOT NULL,
    country_name     VARCHAR2(256)NOT NULL,
    region_id        NUMBER NOT NULL,
    region           VARCHAR2(256) NOT NULL,
    postal_code      VARCHAR2(256) NOT NULL,
    phone            VARCHAR2(256) NOT NULL,
    employee_type    VARCHAR2(256) NOT NULL,
    start_dt         DATE NOT NULL,
    end_dt           DATE NOT NULL,
    current_flag     CHAR(10) NOT NULL,
    update_dt        DATE NOT NULL
);

ALTER TABLE dim_employees_scd ADD CONSTRAINT dim_employees_scd_pk PRIMARY KEY ( employee_dm_surr_id, start_dt );
GRANT SELECT, INSERT, UPDATE ON dim_employees_scd TO BL_CL;
