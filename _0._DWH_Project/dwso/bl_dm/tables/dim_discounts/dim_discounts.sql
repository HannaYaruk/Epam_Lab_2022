--drop TABLE dim_discounts;
CREATE TABLE dim_discounts (
    discount_dm_surr_id    NUMBER NOT NULL,
    discount_id         NUMBER NOT NULL,
    source_system       VARCHAR2(256) NOT NULL,
    source_entity       VARCHAR2(256) NOT NULL,
    discount_title      VARCHAR2(256) NOT NULL,
    discount_percentage NUMBER NOT NULL,
    update_dt         DATE NOT NULL
);

ALTER TABLE dim_discounts ADD CONSTRAINT discounts_pk PRIMARY KEY ( discount_dm_surr_id );
GRANT SELECT, INSERT, UPDATE ON dim_discounts TO BL_CL;