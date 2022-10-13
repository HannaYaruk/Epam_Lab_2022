--drop table fct_payments_dd;
CREATE TABLE fct_payments_dd (
    payment_src_id           NUMBER NOT NULL,
    product_dm_surr_id          NUMBER NOT NULL,    
    employee_dm_surr_id         NUMBER NOT NULL,
    warehouse_dm_surr_id        NUMBER NOT NULL,
    discount_dm_surr_id         NUMBER NOT NULL,
    address_dm_surr_id          NUMBER NOT NULL,
    customer_dm_surr_id         NUMBER NOT NULL,
    payment_type_dm_surr_id     NUMBER NOT NULL,
    product_cost         NUMBER(8, 2) NOT NULL,
    product_price        NUMBER(8, 2) NOT NULL,
    quantity                 NUMBER NOT NULL,
    sale_date                DATE NOT NULL,
    day_id               DATE NOT NULL,
    update_dt              DATE NOT NULL
);
GRANT SELECT, INSERT, UPDATE ON fct_payments_dd TO BL_CL;

ALTER TABLE fct_payments_dd MODIFY
    PARTITION BY RANGE (
        sale_date
    )
    ( PARTITION p1
        VALUES LESS THAN ( TO_DATE('1-1-2020', 'DD-MM-YYYY') ),
    PARTITION p2
        VALUES LESS THAN ( TO_DATE('1-2-2020', 'DD-MM-YYYY') ),
    PARTITION p3
        VALUES LESS THAN ( TO_DATE('1-3-2020', 'DD-MM-YYYY') ),
    PARTITION p4
        VALUES LESS THAN ( TO_DATE('1-4-2020', 'DD-MM-YYYY') ),
    PARTITION p5
        VALUES LESS THAN ( TO_DATE('1-5-2020', 'DD-MM-YYYY') ),
    PARTITION p6
        VALUES LESS THAN ( TO_DATE('1-6-2020', 'DD-MM-YYYY') ),
    PARTITION p7
        VALUES LESS THAN ( TO_DATE('1-7-2020', 'DD-MM-YYYY') ),
    PARTITION p8
        VALUES LESS THAN ( TO_DATE('1-8-2020', 'DD-MM-YYYY') ),
    PARTITION p9
        VALUES LESS THAN ( TO_DATE('1-9-2020', 'DD-MM-YYYY') ),
    PARTITION p10
        VALUES LESS THAN ( TO_DATE('1-10-2020', 'DD-MM-YYYY') ),
    PARTITION p11
        VALUES LESS THAN ( TO_DATE('1-11-2020', 'DD-MM-YYYY') ),
    PARTITION p12
        VALUES LESS THAN ( TO_DATE('1-12-2020', 'DD-MM-YYYY') ),
    PARTITION p13
        VALUES LESS THAN ( TO_DATE('1-1-2021', 'DD-MM-YYYY') ),
    PARTITION p14
        VALUES LESS THAN ( TO_DATE('1-2-2021', 'DD-MM-YYYY') ),
    PARTITION p15
        VALUES LESS THAN ( TO_DATE('1-3-2021', 'DD-MM-YYYY') ),
    PARTITION p16
        VALUES LESS THAN ( TO_DATE('1-4-2021', 'DD-MM-YYYY') ),
    PARTITION p17
        VALUES LESS THAN ( TO_DATE('1-5-2021', 'DD-MM-YYYY') ),
    PARTITION p18
        VALUES LESS THAN ( TO_DATE('1-6-2021', 'DD-MM-YYYY') ),
    PARTITION p19
        VALUES LESS THAN ( TO_DATE('1-7-2021', 'DD-MM-YYYY') ),
    PARTITION p20
        VALUES LESS THAN ( TO_DATE('1-8-2021', 'DD-MM-YYYY') ),
    PARTITION p21
        VALUES LESS THAN ( TO_DATE('1-9-2021', 'DD-MM-YYYY') ),
    PARTITION p22
        VALUES LESS THAN ( TO_DATE('1-10-2021', 'DD-MM-YYYY') ),
    PARTITION p23
        VALUES LESS THAN ( TO_DATE('1-11-2021', 'DD-MM-YYYY') ),
    PARTITION p24
        VALUES LESS THAN ( TO_DATE('1-12-2021', 'DD-MM-YYYY') ),
    PARTITION p25
        VALUES LESS THAN ( TO_DATE('1-1-2022', 'DD-MM-YYYY') ),
    PARTITION p26
        VALUES LESS THAN ( TO_DATE('1-2-2022', 'DD-MM-YYYY') ),
    PARTITION p27
        VALUES LESS THAN ( TO_DATE('1-3-2022', 'DD-MM-YYYY') ),
    PARTITION p28
        VALUES LESS THAN ( TO_DATE('1-4-2022', 'DD-MM-YYYY') ),
    PARTITION p29
        VALUES LESS THAN (MAXVALUE)          
    );
    
--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_addresses_fk FOREIGN KEY ( address_surr_id )
--        REFERENCES dim_addresses ( address_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_customers_fk FOREIGN KEY ( customer_surr_id )
--        REFERENCES dim_customers ( customer_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_discounts_fk FOREIGN KEY ( discount_surr_id )
--        REFERENCES dim_discounts ( discount_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_employees_scd_fk FOREIGN KEY ( employee_surr_id )
--        REFERENCES dim_employees_scd ( employee_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_payment_types_fk FOREIGN KEY ( payment_type_surr_id )
--        REFERENCES dim_payment_types ( payment_type_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_products_fk FOREIGN KEY ( product_surr_id )
--        REFERENCES dim_products ( product_surr_id );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_time_dates_fk FOREIGN KEY ( dim_time_dates_full_date )
--        REFERENCES dim_time_dates ( full_date );

--ALTER TABLE fct_payments_dd
--    ADD CONSTRAINT fct_payments_dd_dim_warehouses_fk FOREIGN KEY ( warehouse_surr_id )
--        REFERENCES dim_warehouses ( warehouse_surr_id );