--CREATE SEQUENCES FOR DM TABLES
--drop SEQUENCE addresses_id_seq_dm
CREATE SEQUENCE addresses_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE customers_id_seq_dm
CREATE SEQUENCE customers_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE discounts_id_seq_dm
CREATE SEQUENCE discounts_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE employees_id_seq_dm
CREATE SEQUENCE employees_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE paym_types_id_seq_dm
CREATE SEQUENCE paym_types_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE payments_id_seq_dm
CREATE SEQUENCE payments_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE products_id_seq_dm
CREATE SEQUENCE products_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE dates_id_seq_dm
CREATE SEQUENCE dates_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--drop SEQUENCE warehouses_id_seq_dm
CREATE SEQUENCE warehouses_id_seq_dm
INCREMENT BY 1
START WITH 1
NOCACHE 
NOCYCLE;

--GRANT PRIVILEGIES ON SEQUENCES
GRANT SELECT ON addresses_id_seq_dm TO BL_CL;
GRANT SELECT ON customers_id_seq_dm TO BL_CL;
GRANT SELECT ON discounts_id_seq_dm TO BL_CL;
GRANT SELECT ON employees_id_seq_dm TO BL_CL;
GRANT SELECT ON paym_types_id_seq_dm TO BL_CL;
GRANT SELECT ON payments_id_seq_dm TO BL_CL;
GRANT SELECT ON products_id_seq_dm TO BL_CL;
GRANT SELECT ON dates_id_seq_dm TO BL_CL;
GRANT SELECT ON warehouses_id_seq_dm TO BL_CL;
