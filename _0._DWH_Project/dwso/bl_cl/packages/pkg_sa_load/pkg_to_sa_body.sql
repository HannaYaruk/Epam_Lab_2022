CREATE OR REPLACE PACKAGE BODY pkg_sa AS

--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_country_regions_bel IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.COUNTRY_REGIONS_SRC' );
        message      VARCHAR2(256) := ( 'COUNTRY_REGIONS_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.country_regions_src  cr
        USING ( SELECT country_id
       ,country_desc
       ,structure_code
       ,structure_desc
       ,current_date
        FROM sa_source_bel.country_regions_ext
              )
        src ON ( cr.country_id = src.country_id)
        WHEN MATCHED THEN UPDATE
        SET cr.country_desc = src.country_desc,
            cr.structure_code = src.structure_code,
            cr.structure_desc = src.structure_desc,
            update_dt = current_date
--        WHERE
--            ( decode(cr.country_desc, src.country_desc, 0, 1) + decode(cr.structure_code, src.structure_code, 0, 1),
--            + decode(cr.structure_desc, src.structure_desc, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            country_id,
            country_desc,
            structure_code,
            structure_desc,
            update_dt)
        VALUES
            ( src.country_id,
            src.country_desc,
            src.structure_code,
            src.structure_desc,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_country_regions_bel;
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_country_shortnames_bel IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.COUNTRY_SHORTNAMES_SRC' );
        message      VARCHAR2(256) := ( 'COUNTRY_SHORTNAMES_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.country_shortnames_src  cr
        USING ( SELECT country_id
       ,country_desc
       ,country_code
       ,current_date
        FROM sa_source_bel.country_shortnames_ext
              )
        src ON ( cr.country_id = src.country_id)
        WHEN MATCHED THEN UPDATE
        SET cr.country_desc = src.country_desc,
            cr.country_code = src.country_code,
            update_dt = current_date
        WHERE
            ( decode(cr.country_desc, src.country_desc, 0, 1) + decode(cr.country_code, src.country_code, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            country_id,
            country_desc,
            country_code,
            update_dt)
        VALUES
            ( src.country_id,
            src.country_desc,
            src.country_code,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_country_shortnames_bel;    

--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_cust_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.CUST_BELG_SRC' );
        message      VARCHAR2(256) := ( 'CUST_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.cust_belg_src  cr
        USING ( SELECT id_cust,
     personal_id,
     first_name,
     last_name,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     current_date
        FROM sa_source_bel.cust_belg_ext
              )
        src ON ( cr.id_cust = src.id_cust)
        WHEN MATCHED THEN UPDATE
        SET cr.personal_id = src.personal_id,
            cr.first_name = src.first_name,
            cr.last_name = src.last_name,            
            cr.address = src.address,            
            cr.city = src.city,           
            cr.country_code = src.country_code,            
            cr.country_name = src.country_name,
            cr.postal_code = src.postal_code,             
            cr.phone = src.phone,             
            update_dt = current_date
        WHERE
            ( decode(cr.personal_id, src.personal_id, 0, 1) + decode(cr.first_name, src.first_name, 0, 1)
            + decode(cr.last_name, src.last_name, 0, 1) + decode(cr.address, src.address, 0, 1)
            + decode(cr.city, src.city, 0, 1) + decode(cr.country_code, src.country_code, 0, 1)
            + decode(cr.country_name, src.country_name, 0, 1) + decode(cr.postal_code, src.postal_code, 0, 1)            
            + decode(cr.phone, src.phone, 0, 1)             
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_cust,
     personal_id,
     first_name,
     last_name,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     update_dt)
        VALUES
            ( src.id_cust,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.address,
            src.city,
            src.country_code,
            src.country_name,
            src.postal_code,
            src.phone,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_cust_belg_src;    

    PROCEDURE prc_sa_discounts_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.DISCOUNTS_SRC' );
        message      VARCHAR2(256) := ( 'DISCOUNTS_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.discounts_src  cr
        USING ( SELECT id_disc,
     title,
     percentage,
     current_date
        FROM sa_source_bel.discounts_ext
              )
        src ON ( cr.id_disc = src.id_disc)
        WHEN MATCHED THEN UPDATE
        SET cr.title = src.title,
            cr.percentage = src.percentage,         
            update_dt = current_date
        WHERE
            ( decode(cr.title, src.title, 0, 1) + decode(cr.percentage, src.percentage, 0, 1)            
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
           id_disc,
     title,
     percentage,
     update_dt)
        VALUES
            ( src.id_disc,
            src.title,
            src.percentage,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_discounts_src;    

--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_emp_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.EMP_BELG_SRC' );
        message      VARCHAR2(256) := ( 'EMP_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.emp_belg_src  cr
        USING ( SELECT id_emp,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     emp_type,
     start_dt,
     end_dt,
     curr_flag,
     current_date
        FROM sa_source_bel.emp_belg_ext
              )
        src ON ( cr.id_emp = src.id_emp)
        WHEN MATCHED THEN UPDATE
        SET cr.personal_id = src.personal_id,
            cr.first_name = src.first_name,
            cr.last_name = src.last_name,
            cr.email = src.email,            
            cr.address = src.address,            
            cr.city = src.city,           
            cr.country_code = src.country_code,            
            cr.country_name = src.country_name,
            cr.postal_code = src.postal_code,             
            cr.phone = src.phone,
            cr.emp_type = src.emp_type,            
            cr.start_dt = src.start_dt,           
            cr.end_dt = src.end_dt,            
            cr.curr_flag = src.curr_flag,            
            update_dt = current_date
        WHERE
            ( decode(cr.personal_id, src.personal_id, 0, 1) + decode(cr.first_name, src.first_name, 0, 1)
            + decode(cr.last_name, src.last_name, 0, 1) + decode(cr.address, src.address, 0, 1)
            + decode(cr.city, src.city, 0, 1) + decode(cr.country_code, src.country_code, 0, 1)
            + decode(cr.country_name, src.country_name, 0, 1) + decode(cr.postal_code, src.postal_code, 0, 1)            
            + decode(cr.phone, src.phone, 0, 1) + decode(cr.email, src.email, 0, 1)
            + decode(cr.emp_type, src.emp_type, 0, 1) + decode(cr.start_dt, src.start_dt, 0, 1)  
            + decode(cr.end_dt, src.end_dt, 0, 1) + decode(cr.curr_flag, src.curr_flag, 0, 1)  
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_emp,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     emp_type,
     start_dt,
     end_dt,
     curr_flag,
     update_dt)
        VALUES
            ( src.id_emp,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.address,
            src.email,
            src.city,
            src.country_code,
            src.country_name,
            src.postal_code,
            src.phone,
            src.emp_type,
            src.start_dt,
            src.end_dt,
            src.curr_flag,            
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_emp_belg_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_paym_type_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.PAYM_TYPE_BELG_SRC' );
        message      VARCHAR2(256) := ( 'PAYM_TYPE_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.paym_type_belg_src  cr
        USING ( SELECT id_paym_type,
     paym_type,
     paym_acc,
     current_date
        FROM sa_source_bel.paym_type_belg_ext
        WHERE paym_type IS NOT NULL
              )
        src ON ( cr.id_paym_type = src.id_paym_type)
        WHEN MATCHED THEN UPDATE
        SET cr.paym_type = src.paym_type,
            cr.paym_acc = src.paym_acc,          
            update_dt = current_date
        WHERE
            ( decode(cr.paym_type, src.paym_type, 0, 1) + decode(cr.paym_acc, src.paym_acc, 0, 1)
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_paym_type,
     paym_type,
     paym_acc,
     update_dt)
        VALUES
            ( src.id_paym_type,
            src.paym_type,
            src.paym_acc,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_paym_type_belg_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_paym_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.PAYMENT_BELG_SRC' );
        message      VARCHAR2(256) := ( 'PAYMENT_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.payment_belg_src  cr
        USING ( SELECT payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , current_date
        FROM sa_source_bel.payment_belg_ext
              )
        src ON ( cr.payment_id = src.payment_id)
        WHEN MATCHED THEN UPDATE
        SET cr.product_id = src.product_id,
            cr.customer_id = src.customer_id,
            cr.employee_id = src.employee_id,
            cr.warehouse_id = src.warehouse_id,            
            cr.payment_type_id = src.payment_type_id,            
            cr.discount_id = src.discount_id,           
            cr.quantity = src.quantity,            
            cr.sale_date = src.sale_date,            
            update_dt = current_date
        WHERE
            ( decode(cr.product_id, src.product_id, 0, 1) + decode(cr.customer_id, src.customer_id, 0, 1)
            + decode(cr.employee_id, src.employee_id, 0, 1) + decode(cr.warehouse_id, src.warehouse_id, 0, 1)
            + decode(cr.payment_type_id, src.payment_type_id, 0, 1) + decode(cr.discount_id, src.discount_id, 0, 1)
            + decode(cr.quantity, src.quantity, 0, 1) + decode(cr.sale_date, src.sale_date, 0, 1)             
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , update_dt)
        VALUES
            ( src.payment_id,
            src.product_id,
            src.customer_id,
            src.employee_id,
            src.warehouse_id,
            src.payment_type_id,
            src.discount_id,
            src.quantity,
            src.sale_date,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_paym_belg_src; 
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_product_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.PROD_BELG_SRC' );
        message      VARCHAR2(256) := ( 'PROD_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.prod_belg_src  cr
        USING ( SELECT product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     current_date
        FROM sa_source_bel.prod_belg_ext
              )
        src ON ( cr.product_id = src.product_id)
        WHEN MATCHED THEN UPDATE
        SET cr.product_name = src.product_name,
            cr.product_desc = src.product_desc,
            cr.category_name = src.category_name,
            cr.product_cost = src.product_cost,            
            cr.product_price = src.product_price,            
            cr.warehouse_id = src.warehouse_id,           
            cr.warehouse_name = src.warehouse_name,            
            cr.warehouse_address = src.warehouse_address,
            cr.warehouse_city = src.warehouse_city,             
            cr.warehouse_country_code = src.warehouse_country_code,
            cr.warehouse_country_name = src.warehouse_country_name,            
            cr.warehouse_postal_code = src.warehouse_postal_code,           
            cr.warehouse_phone = src.warehouse_phone, 
            cr.total = src.total,                      
            update_dt = current_date
        WHERE
            ( decode(cr.product_name, src.product_name, 0, 1) + decode(cr.product_desc, src.product_desc, 0, 1)
            + decode(cr.product_desc, src.product_desc, 0, 1) + decode(cr.product_cost, src.product_cost, 0, 1)
            + decode(cr.product_price, src.product_price, 0, 1) + decode(cr.warehouse_id, src.warehouse_id, 0, 1)
            + decode(cr.warehouse_name, src.warehouse_name, 0, 1) + decode(cr.warehouse_address, src.warehouse_address, 0, 1)            
            + decode(cr.warehouse_city, src.warehouse_city, 0, 1) + decode(cr.warehouse_country_code, src.warehouse_country_code, 0, 1)
            + decode(cr.warehouse_country_name, src.warehouse_country_name, 0, 1) + decode(cr.warehouse_postal_code, src.warehouse_postal_code, 0, 1)  
            + decode(cr.warehouse_phone, src.warehouse_phone, 0, 1) + decode(cr.total, src.total, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     update_dt)
        VALUES
            ( src.product_id,
            src.product_id,
            src.product_desc,
            src.category_name,
            src.product_cost,
            src.product_price,
            src.warehouse_id,
            src.warehouse_name,
            src.warehouse_address,
            src.warehouse_city,
            src.warehouse_country_code,
            src.warehouse_country_name,
            src.warehouse_postal_code,
            src.warehouse_phone,
            src.total,            
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_product_belg_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_wareh_belg_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_BEL_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_BEL.WAREH_BELG_SRC' );
        message      VARCHAR2(256) := ( 'WAREH_BELG_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_BEL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_bel.wareh_belg_src  cr
        USING ( SELECT warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     current_date
        FROM sa_source_bel.wareh_belg_ext
              )
        src ON ( cr.warehouse_id = src.warehouse_id)
        WHEN MATCHED THEN UPDATE
        SET cr.warehouse_name = src.warehouse_name,
            cr.warehouse_address = src.warehouse_address,
            cr.warehouse_city = src.warehouse_city,
            cr.warehouse_country_code = src.warehouse_country_code,            
            cr.warehouse_country_name = src.warehouse_country_name,            
            cr.warehouse_postal_code = src.warehouse_postal_code,           
            cr.warehouse_phone = src.warehouse_phone,            
            cr.total = src.total,
            update_dt = current_date
        WHERE
            ( decode(cr.warehouse_name, src.warehouse_name, 0, 1) + decode(cr.warehouse_address, src.warehouse_address, 0, 1)
            + decode(cr.warehouse_city, src.warehouse_city, 0, 1) + decode(cr.warehouse_country_code, src.warehouse_country_code, 0, 1)
            + decode(cr.warehouse_country_name, src.warehouse_country_name, 0, 1) + decode(cr.warehouse_postal_code, src.warehouse_postal_code, 0, 1)
            + decode(cr.warehouse_phone, src.warehouse_phone, 0, 1) + decode(cr.total, src.total, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     update_dt)
        VALUES
            ( src.warehouse_id,
            src.warehouse_name,
            src.warehouse_address,
            src.warehouse_city,
            src.warehouse_country_code,
            src.warehouse_country_name,
            src.warehouse_postal_code,
            src.warehouse_phone,
            src.total,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_wareh_belg_src;

--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_cust_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_FRA_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_FRA.CUST_FRA_SRC' );
        message      VARCHAR2(256) := ( 'CUST_FRA_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_FRA' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.cust_fra_src  cr
        USING ( SELECT id_cust,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     current_date
        FROM sa_source_fra.cust_fra_ext
              )
        src ON ( cr.id_cust = src.id_cust)
        WHEN MATCHED THEN UPDATE
        SET cr.personal_id = src.personal_id,
            cr.first_name = src.first_name,
            cr.last_name = src.last_name,
            cr.email = src.email,            
            cr.address = src.address,            
            cr.city = src.city,           
            cr.country_code = src.country_code,            
            cr.country_name = src.country_name,
            cr.postal_code = src.postal_code,             
            cr.phone = src.phone,             
            update_dt = current_date
        WHERE
            ( decode(cr.personal_id, src.personal_id, 0, 1) + decode(cr.first_name, src.first_name, 0, 1)
            + decode(cr.last_name, src.last_name, 0, 1) + decode(cr.address, src.address, 0, 1)
            + decode(cr.city, src.city, 0, 1) + decode(cr.country_code, src.country_code, 0, 1)
            + decode(cr.country_name, src.country_name, 0, 1) + decode(cr.postal_code, src.postal_code, 0, 1)            
            + decode(cr.phone, src.phone, 0, 1) + decode(cr.email, src.email, 0, 1)            
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_cust,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     update_dt)
        VALUES
            ( src.id_cust,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.email,
            src.address,
            src.city,
            src.country_code,
            src.country_name,
            src.postal_code,
            src.phone,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_cust_fra_src;     

--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_emp_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_FRA_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_FRA.EMP_fra_SRC' );
        message      VARCHAR2(256) := ( 'EMP_FRA_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_FRA' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.emp_fra_src  cr
        USING ( SELECT id_emp,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     emp_type,
     start_dt,
     end_dt,
     curr_flag,
     current_date
        FROM sa_source_fra.emp_fra_ext
              )
        src ON ( cr.id_emp = src.id_emp)
        WHEN MATCHED THEN UPDATE
        SET cr.personal_id = src.personal_id,
            cr.first_name = src.first_name,
            cr.last_name = src.last_name,
            cr.email = src.email,            
            cr.address = src.address,            
            cr.city = src.city,           
            cr.country_code = src.country_code,            
            cr.country_name = src.country_name,
            cr.postal_code = src.postal_code,             
            cr.phone = src.phone,
            cr.emp_type = src.emp_type,            
            cr.start_dt = src.start_dt,           
            cr.end_dt = src.end_dt,            
            cr.curr_flag = src.curr_flag,            
            update_dt = current_date
        WHERE
            ( decode(cr.personal_id, src.personal_id, 0, 1) + decode(cr.first_name, src.first_name, 0, 1)
            + decode(cr.last_name, src.last_name, 0, 1) + decode(cr.address, src.address, 0, 1)
            + decode(cr.city, src.city, 0, 1) + decode(cr.country_code, src.country_code, 0, 1)
            + decode(cr.country_name, src.country_name, 0, 1) + decode(cr.postal_code, src.postal_code, 0, 1)            
            + decode(cr.phone, src.phone, 0, 1) + decode(cr.email, src.email, 0, 1)
            + decode(cr.emp_type, src.emp_type, 0, 1) + decode(cr.start_dt, src.start_dt, 0, 1)  
            + decode(cr.end_dt, src.end_dt, 0, 1) + decode(cr.curr_flag, src.curr_flag, 0, 1)  
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_emp,
     personal_id,
     first_name,
     last_name,
     email,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     emp_type,
     start_dt,
     end_dt,
     curr_flag,
     update_dt)
        VALUES
            ( src.id_emp,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.address,
            src.email,
            src.city,
            src.country_code,
            src.country_name,
            src.postal_code,
            src.phone,
            src.emp_type,
            src.start_dt,
            src.end_dt,
            src.curr_flag,            
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_emp_fra_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_paym_type_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_fra_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_fra.PAYM_TYPE_fra_SRC' );
        message      VARCHAR2(256) := ( 'PAYM_TYPE_fra_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_fra' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.paym_type_fra_src  cr
        USING ( SELECT id_paym_type,
     paym_type,
     paym_acc,
     current_date
        FROM sa_source_fra.paym_type_fra_ext
        WHERE paym_type IS NOT NULL
              )
        src ON ( cr.id_paym_type = src.id_paym_type)
        WHEN MATCHED THEN UPDATE
        SET cr.paym_type = src.paym_type,
            cr.paym_acc = src.paym_acc,          
            update_dt = current_date
        WHERE
            ( decode(cr.paym_type, src.paym_type, 0, 1) + decode(cr.paym_acc, src.paym_acc, 0, 1)
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            id_paym_type,
     paym_type,
     paym_acc,
     update_dt)
        VALUES
            ( src.id_paym_type,
            src.paym_type,
            src.paym_acc,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_paym_type_fra_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_paym_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_fra_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_fra.PAYMENT_fra_SRC' );
        message      VARCHAR2(256) := ( 'PAYMENT_fra_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_fra' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.payment_fra_src  cr
        USING ( SELECT payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , current_date
        FROM sa_source_fra.payment_fra_ext
              )
        src ON ( cr.payment_id = src.payment_id)
        WHEN MATCHED THEN UPDATE
        SET cr.product_id = src.product_id,
            cr.customer_id = src.customer_id,
            cr.employee_id = src.employee_id,
            cr.warehouse_id = src.warehouse_id,            
            cr.payment_type_id = src.payment_type_id,            
            cr.discount_id = src.discount_id,           
            cr.quantity = src.quantity,            
            cr.sale_date = src.sale_date,            
            update_dt = current_date
        WHERE
            ( decode(cr.product_id, src.product_id, 0, 1) + decode(cr.customer_id, src.customer_id, 0, 1)
            + decode(cr.employee_id, src.employee_id, 0, 1) + decode(cr.warehouse_id, src.warehouse_id, 0, 1)
            + decode(cr.payment_type_id, src.payment_type_id, 0, 1) + decode(cr.discount_id, src.discount_id, 0, 1)
            + decode(cr.quantity, src.quantity, 0, 1) + decode(cr.sale_date, src.sale_date, 0, 1)             
            > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            payment_id
    , product_id
    , customer_id
    , employee_id
    , warehouse_id
    , payment_type_id
    , discount_id
    , quantity
    , sale_date
    , update_dt)
        VALUES
            ( src.payment_id,
            src.product_id,
            src.customer_id,
            src.employee_id,
            src.warehouse_id,
            src.payment_type_id,
            src.discount_id,
            src.quantity,
            src.sale_date,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_paym_fra_src; 
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_product_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_fra_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_fra.PROD_fra_SRC' );
        message      VARCHAR2(256) := ( 'PROD_fra_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_fra' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.prod_fra_src  cr
        USING ( SELECT product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     current_date
        FROM sa_source_fra.prod_fra_ext
              )
        src ON ( cr.product_id = src.product_id)
        WHEN MATCHED THEN UPDATE
        SET cr.product_name = src.product_name,
            cr.product_desc = src.product_desc,
            cr.category_name = src.category_name,
            cr.product_cost = src.product_cost,            
            cr.product_price = src.product_price,            
            cr.warehouse_id = src.warehouse_id,           
            cr.warehouse_name = src.warehouse_name,            
            cr.warehouse_address = src.warehouse_address,
            cr.warehouse_city = src.warehouse_city,             
            cr.warehouse_country_code = src.warehouse_country_code,
            cr.warehouse_country_name = src.warehouse_country_name,            
            cr.warehouse_postal_code = src.warehouse_postal_code,           
            cr.warehouse_phone = src.warehouse_phone, 
            cr.total = src.total,                      
            update_dt = current_date
        WHERE
            ( decode(cr.product_name, src.product_name, 0, 1) + decode(cr.product_desc, src.product_desc, 0, 1)
            + decode(cr.product_desc, src.product_desc, 0, 1) + decode(cr.product_cost, src.product_cost, 0, 1)
            + decode(cr.product_price, src.product_price, 0, 1) + decode(cr.warehouse_id, src.warehouse_id, 0, 1)
            + decode(cr.warehouse_name, src.warehouse_name, 0, 1) + decode(cr.warehouse_address, src.warehouse_address, 0, 1)            
            + decode(cr.warehouse_city, src.warehouse_city, 0, 1) + decode(cr.warehouse_country_code, src.warehouse_country_code, 0, 1)
            + decode(cr.warehouse_country_name, src.warehouse_country_name, 0, 1) + decode(cr.warehouse_postal_code, src.warehouse_postal_code, 0, 1)  
            + decode(cr.warehouse_phone, src.warehouse_phone, 0, 1) + decode(cr.total, src.total, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            product_id,
     product_name,
     product_desc,
     category_name,
     product_cost,
     product_price,
     warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     update_dt)
        VALUES
            ( src.product_id,
            src.product_id,
            src.product_desc,
            src.category_name,
            src.product_cost,
            src.product_price,
            src.warehouse_id,
            src.warehouse_name,
            src.warehouse_address,
            src.warehouse_city,
            src.warehouse_country_code,
            src.warehouse_country_name,
            src.warehouse_postal_code,
            src.warehouse_phone,
            src.total,            
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_product_fra_src;  
    
--CREATE PROCEDURE FOR INSERTING DATA TO TABLE
    PROCEDURE prc_sa_wareh_fra_src IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'SA_fra_Loading' );
        tagret_table VARCHAR2(256) := ( 'SA_SOURCE_fra.WAREH_fra_SRC' );
        message      VARCHAR2(256) := ( 'WAREH_fra_SRC insert' );
        user_name    VARCHAR2(256) := ( 'SA_SOURCE_fra' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO sa_source_fra.wareh_fra_src  cr
        USING ( SELECT warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     current_date
        FROM sa_source_fra.wareh_fra_ext
              )
        src ON ( cr.warehouse_id = src.warehouse_id)
        WHEN MATCHED THEN UPDATE
        SET cr.warehouse_name = src.warehouse_name,
            cr.warehouse_address = src.warehouse_address,
            cr.warehouse_city = src.warehouse_city,
            cr.warehouse_country_code = src.warehouse_country_code,            
            cr.warehouse_country_name = src.warehouse_country_name,            
            cr.warehouse_postal_code = src.warehouse_postal_code,           
            cr.warehouse_phone = src.warehouse_phone,            
            cr.total = src.total,
            update_dt = current_date
        WHERE
            ( decode(cr.warehouse_name, src.warehouse_name, 0, 1) + decode(cr.warehouse_address, src.warehouse_address, 0, 1)
            + decode(cr.warehouse_city, src.warehouse_city, 0, 1) + decode(cr.warehouse_country_code, src.warehouse_country_code, 0, 1)
            + decode(cr.warehouse_country_name, src.warehouse_country_name, 0, 1) + decode(cr.warehouse_postal_code, src.warehouse_postal_code, 0, 1)
            + decode(cr.warehouse_phone, src.warehouse_phone, 0, 1) + decode(cr.total, src.total, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (warehouse_id,
     warehouse_name,
     warehouse_address,
     warehouse_city,
     warehouse_country_code,
     warehouse_country_name,
     warehouse_postal_code,
     warehouse_phone,
     total,
     update_dt)
        VALUES
            ( src.warehouse_id,
            src.warehouse_name,
            src.warehouse_address,
            src.warehouse_city,
            src.warehouse_country_code,
            src.warehouse_country_name,
            src.warehouse_postal_code,
            src.warehouse_phone,
            src.total,
            current_date);

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_sa_wareh_fra_src;  
    
END pkg_sa;

--EXECUTE pkg_sa.prc_sa_country_regions_bel;
--EXECUTE pkg_sa.prc_sa_country_shortnames_bel;
--EXECUTE pkg_sa.prc_sa_cust_belg_src;
--EXECUTE pkg_sa.prc_sa_discounts_src;
--EXECUTE pkg_sa.prc_sa_emp_belg_src;
--EXECUTE pkg_sa.prc_sa_paym_type_belg_src;
--EXECUTE pkg_sa.prc_sa_paym_belg_src;
--EXECUTE pkg_sa.prc_sa_product_belg_src;
--EXECUTE pkg_sa.prc_sa_wareh_belg_src;
--EXECUTE pkg_sa.prc_sa_cust_fra_src;
--EXECUTE pkg_sa.prc_sa_emp_fra_src;
--EXECUTE pkg_sa.prc_sa_paym_type_fra_src;
--EXECUTE pkg_sa.prc_sa_paym_fra_src;
--EXECUTE pkg_sa.prc_sa_product_fra_src;
--EXECUTE pkg_sa.prc_sa_wareh_fra_src;

--select * from sa_source_fra.wareh_fra_src;
