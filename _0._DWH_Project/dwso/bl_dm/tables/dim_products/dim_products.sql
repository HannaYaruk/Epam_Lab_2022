--drop TABLE dim_products;
CREATE TABLE dim_products (
    product_dm_surr_id NUMBER NOT NULL,
    product_id      NUMBER NOT NULL,
    source_system   VARCHAR2(256) NOT NULL,
    source_entity   VARCHAR2(256) NOT NULL,
    product_name    VARCHAR2(256) NOT NULL,
    product_desc    VARCHAR2(256) NOT NULL,
    category_id     NUMBER NOT NULL,
    category_name   VARCHAR2(256) NOT NULL,
    product_cost    NUMBER NOT NULL,
    product_price   NUMBER NOT NULL,
    total_unit      NUMBER NOT NULL,
    update_dt       DATE NOT NULL
);

ALTER TABLE dim_products ADD CONSTRAINT dim_products_pk PRIMARY KEY ( product_dm_surr_id );
GRANT SELECT, INSERT, UPDATE ON dim_products TO BL_CL;