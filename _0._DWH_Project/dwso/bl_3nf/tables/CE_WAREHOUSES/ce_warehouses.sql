--DROP TABLE CE_WAREHOUSES;     
CREATE TABLE CE_WAREHOUSES
    (WAREHOUSE_SURR_ID NUMBER (38,0),
     WAREHOUSE_SRC_ID VARCHAR (256) NOT NULL,
     SOURCE_SRC_SYSTEM VARCHAR (256) NOT NULL,
     SOURCE_SRC_ENTITY VARCHAR (256) NOT NULL,
     WAREHOUSE_NAME VARCHAR (256) NOT NULL,
     ADDRESS_SURR_ID NUMBER (38,0) NOT NULL,
     TOTAL_POSITIONS NUMBER (38,0) NOT NULL,
     UPDATE_DT DATE DEFAULT sysdate NOT NULL,
     PRIMARY KEY(WAREHOUSE_SURR_ID)
     ,constraint fk_address_w FOREIGN KEY(ADDRESS_SURR_ID) REFERENCES CE_ADDRESSES (ADDRESS_SURR_ID)
);
     
GRANT SELECT, INSERT, UPDATE ON ce_warehouses TO BL_CL;