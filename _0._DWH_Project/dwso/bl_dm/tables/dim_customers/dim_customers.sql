--drop TABLE dim_customers
CREATE TABLE dim_customers (
    customer_dm_surr_id NUMBER NOT NULL,
    customer_id      NUMBER NOT NULL,
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
    update_dt        DATE NOT NULL
);

ALTER TABLE dim_customers ADD CONSTRAINT dim_customers_pk PRIMARY KEY ( customer_dm_surr_id );
GRANT SELECT, INSERT, UPDATE ON dim_customers TO BL_CL;