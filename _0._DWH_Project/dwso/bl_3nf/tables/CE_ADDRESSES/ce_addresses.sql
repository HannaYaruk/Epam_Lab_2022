--ALTER TABLE bl_3nf.ce_payments_dd DISABLE CONSTRAINT fk_address
--ALTER TABLE bl_3nf.ce_employees_scd DISNABLE CONSTRAINT fk_address_e
--DROP TABLE CE_ADDRESSES;     
CREATE TABLE CE_ADDRESSES
    (ADDRESS_SURR_ID NUMBER (38,0),
     ADDRESS_SRC_ID VARCHAR (256) NOT NULL,
     SOURCE_SRC_SYSTEM VARCHAR (256) NOT NULL,
     SOURCE_SRC_ENTITY VARCHAR (256) NOT NULL,
     ADDRESS VARCHAR (256) NOT NULL,
     CITY_SURR_ID NUMBER (38,0) NOT NULL,
     POSTAL_CODE VARCHAR (256) NOT NULL,
     PHONE VARCHAR (256) NOT NULL,
     UPDATE_DT DATE DEFAULT sysdate NOT NULL,
     PRIMARY KEY(ADDRESS_SURR_ID)
     , constraint fk_city_a FOREIGN KEY(CITY_SURR_ID) REFERENCES CE_CITIES (CITY_SURR_ID)
     );
     
GRANT SELECT, INSERT, UPDATE ON ce_addresses TO BL_CL;