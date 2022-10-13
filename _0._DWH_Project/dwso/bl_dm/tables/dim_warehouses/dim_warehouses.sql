--drop TABLE dim_warehouses;
CREATE TABLE dim_warehouses (
    warehouse_dm_surr_id NUMBER NOT NULL,
    warehouse_id      NUMBER NOT NULL,
    source_system     VARCHAR2(256) NOT NULL,
    source_entity     VARCHAR2(256) NOT NULL,
    warehouse_name    VARCHAR2(256) NOT NULL,    
    address_id        NUMBER NOT NULL,
    address           VARCHAR2(256) NOT NULL,
    city_id           NUMBER NOT NULL,
    city              VARCHAR2(256) NOT NULL,
    country_id        NUMBER NOT NULL,
    country_code      VARCHAR2(256) NOT NULL,
    country_name      VARCHAR2(256)NOT NULL,
    region_id         NUMBER NOT NULL,
    region            VARCHAR2(256) NOT NULL,
    postal_code       VARCHAR2(256)NOT NULL,
    phone             VARCHAR2(256) NOT NULL,
    update_dt         DATE NOT NULL
);

ALTER TABLE dim_warehouses ADD CONSTRAINT dim_warehouses_pk PRIMARY KEY ( warehouse_dm_surr_id );
GRANT SELECT, INSERT, UPDATE ON dim_warehouses TO BL_CL;