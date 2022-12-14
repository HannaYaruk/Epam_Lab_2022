--DROP TABLE CE_DISCOUNTS; 
CREATE TABLE CE_DISCOUNTS
    (DISCOUNT_SURR_ID NUMBER (38,0),
     DISCOUNT_SRC_ID VARCHAR (256) NOT NULL,
     SOURCE_SRC_SYSTEM VARCHAR (256) NOT NULL,
     SOURCE_SRC_ENTITY VARCHAR (256) NOT NULL,
     DISCOUNT_TITLE VARCHAR (256) NOT NULL,
     DISCOUNT_PERCENTAGE NUMBER (38,0) NOT NULL,
     UPDATE_DT DATE DEFAULT sysdate NOT NULL,
     PRIMARY KEY(DISCOUNT_SURR_ID));
     
GRANT SELECT, INSERT, UPDATE ON ce_discounts TO BL_CL;