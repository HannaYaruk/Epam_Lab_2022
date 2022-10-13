CREATE OR REPLACE PACKAGE BODY pkg_dm AS

    PROCEDURE prc_dim_customers IS

        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DIM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_CUSTOMERS' );
        message      VARCHAR2(256) := ( 'DIM_Loading insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_dm.dim_customers dm
        USING (
                  SELECT
                      c.customer_surr_id  AS cust_sur,
                      'BL_3NF'            AS src_system,
                      'CE_CUSTOMERS'      AS src_entity,
                      c.personal_id       AS pers_id,
                      c.first_name        AS cname,
                      c.last_name         AS lname,
                      c.email             AS mail,
                      a.address_surr_id   AS a_id,
                      a.address           AS addr,
                      ct.city_surr_id     AS c_id,
                      ct.city             AS cty,
                      ctr.country_surr_id AS ctr_id,
                      ctr.country_code    AS ccode,
                      ctr.country_name    AS ctrname,
                      r.region_surr_id    AS reg_id,
                      r.region            AS reg,
                      a.postal_code       AS code,
                      a.phone             AS ph
                  FROM
                      bl_3nf.ce_customers c
                      LEFT JOIN bl_3nf.ce_addresses a ON c.address_surr_id = a.address_surr_id
                      LEFT JOIN bl_3nf.ce_cities    ct ON a.city_surr_id = ct.city_surr_id
                      LEFT JOIN bl_3nf.ce_countries ctr ON ct.country_surr_id = ctr.country_surr_id
                      LEFT JOIN bl_3nf.ce_regions   r ON ctr.region_surr_id = r.region_surr_id
                  WHERE
                      c.customer_surr_id != - 1
              )
        src ON ( dm.customer_id = src.cust_sur
                 AND dm.source_system = src.src_system
                 AND dm.source_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET dm.personal_id = src.pers_id,
            dm.first_name = src.cname,
            dm.last_name = src.lname,
            dm.email = src.mail,
            dm.address_id = src.a_id,
            dm.address = src.addr,
            dm.city_id = src.c_id,
            dm.city = src.cty,
            dm.country_id = src.ctr_id,
            dm.country_code = src.ccode,
            dm.country_name = src.ctrname,
            dm.region_id = src.reg_id,
            dm.region = src.reg,
            dm.postal_code = src.code,
            dm.phone = src.ph,
            dm.update_dt = sysdate
        WHERE
            decode(dm.personal_id, src.pers_id, 0, 1) + decode(dm.first_name, src.cname, 0, 1) + decode(dm.last_name, src.lname, 0, 1) +
            decode(dm.email, src.mail, 0, 1) + decode(dm.address_id, src.a_id, 0, 1) + decode(dm.address, src.addr, 0, 1) + decode(dm.
            city_id, src.c_id, 0, 1) + decode(dm.city, src.cty, 0, 1) + decode(dm.country_id, src.ctr_id, 0, 1) + decode(dm.country_code,
            src.ccode, 0, 1) + decode(dm.country_name, src.ctrname, 0, 1) + decode(dm.region_id, src.reg_id, 0, 1) + decode(dm.region,
            src.reg, 0, 1) + decode(dm.postal_code, src.code, 0, 1) + decode(dm.phone, src.ph, 0, 1) > 0
        WHEN NOT MATCHED THEN
        INSERT (
            customer_dm_surr_id,
            customer_id,
            source_system,
            source_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_id,
            address,
            city_id,
            city,
            country_id,
            country_code,
            country_name,
            region_id,
            region,
            postal_code,
            phone,
            update_dt )
        VALUES
            ( bl_dm.customers_id_seq_dm.nextval,
              src.cust_sur,
              src.src_system,
              src.src_entity,
              src.pers_id,
              src.cname,
              src.lname,
              src.mail,
              src.a_id,
              src.addr,
              src.c_id,
              src.cty,
              src.ctr_id,
              src.ccode,
              src.ctrname,
              src.reg_id,
              src.reg,
              src.code,
              src.ph,
              current_date );

        row_count := SQL%rowcount;
        end_date := localtimestamp;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_dim_customers;
    
-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE DIM_EMPLOYEES_SCD
    PROCEDURE prc_dim_employees_scd IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_EMPLOYEES_SCD' );
        message      VARCHAR2(256) := ( 'DIM_EMPLOYEES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--INSERT FIRST PORTION OF DATA
        MERGE INTO bl_dm.dim_employees_scd e
        USING (
                  SELECT DISTINCT
                      employee_surr_id    AS e_surr,
                      'BL_3NF'            AS src_system,
                      'CE_EMPLOYEES_SCD'  AS src_entity,
                      personal_id         AS p_id,
                      first_name          AS f_name,
                      last_name           AS l_name,
                      email               AS mail,
                      a.address_surr_id   AS a_surr,
                      address             AS addr,
                      c.city_surr_id      AS c_surr,
                      city                AS cty,
                      ctr.country_surr_id AS ctr_surr,
                      country_code        AS c_code,
                      country_name        AS c_name,
                      r.region_surr_id    AS r_surr,
                      region              AS reg,
                      postal_code         AS p_code,
                      phone               AS p_hone,
                      employee_type       AS e_type,
                      start_dt            AS s_dt,
                      end_dt              AS e_dt,
                      current_flag        AS c_flag
                  FROM
                      bl_3nf.ce_employees_scd emp
                      LEFT JOIN bl_3nf.ce_addresses     a ON emp.address_surr_id = a.address_surr_id
                      LEFT JOIN bl_3nf.ce_cities        c ON a.city_surr_id = c.city_surr_id
                      LEFT JOIN bl_3nf.ce_countries     ctr ON c.country_surr_id = ctr.country_surr_id
                      LEFT JOIN bl_3nf.ce_regions       r ON ctr.region_surr_id = r.region_surr_id
              )
        src ON ( e.employee_id = src.e_surr
                 AND e.source_system = src.src_system
                 AND e.source_entity = src.src_entity
                 AND e.start_dt = src.s_dt )
        WHEN MATCHED THEN UPDATE
        SET e.personal_id = src.p_id,
            e.first_name = src.f_name,
            e.last_name = src.l_name,
            e.email = src.mail,
            e.employee_type = src.e_type,
            e.end_dt = src.e_dt,
            e.current_flag = src.c_flag,
            e.phone = src.p_hone,
            e.postal_code = src.p_code,
            e.address = src.addr,
            e.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            employee_dm_surr_id,
            employee_id,
            source_system,
            source_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_id,
            address,
            city_id,
            city,
            country_id,
            country_code,
            country_name,
            region_id,
            region,
            postal_code,
            phone,
            employee_type,
            start_dt,
            end_dt,
            current_flag,
            update_dt )
        VALUES
            ( bl_dm.employees_id_seq_dm.nextval,
              src.e_surr,
              src.src_system,
              src.src_entity,
              src.p_id,
              src.f_name,
              src.l_name,
              src.mail,
              src.a_surr,
              src.addr,
              src.c_surr,
              src.cty,
              src.ctr_surr,
              src.c_code,
              src.c_name,
              src.r_surr,
              src.reg,
              src.p_code,
              src.p_hone,
              src.e_type,
              src.s_dt,
              src.e_dt,
              src.c_flag,
              current_date );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count); 
               
--Write the data into META table
        INSERT INTO prm_mta_incremental_load (
            table_name,
            target_table_name,
            package_ttl,
            procedure_ttl,
            previous_loaded_dt
        ) VALUES (
            'ce_employees_scd',
            'dim_employees_scd',
            'pkg_dm',
            'prc_dim_employees_scd',
            current_date
        );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for ce_employees_scd', user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_dim_employees_scd;
    
--CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE DIM_PRODUCTS
    PROCEDURE prc_dim_products IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_PRODUCTS' );
        message      VARCHAR2(256) := ( 'DIM_PRODUCTS insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

--INSERT DATA
        MERGE INTO bl_dm.dim_products p
        USING (
                  SELECT DISTINCT
                      product_surr_id,
                      'BL_3NF'      AS src_system,
                      'CE_PRODUCTS' AS src_entity,
                      product_name,
                      product_desc,
                      c.category_surr_id,
                      category_name,
                      product_cost,
                      product_price,
                      total_unit,
                      pr.update_dt
                  FROM
                      bl_3nf.ce_products   pr
                      LEFT JOIN bl_3nf.ce_categories c ON pr.category_surr_id = c.category_surr_id
                  WHERE
                      pr.product_surr_id != - 1
              )
        src ON ( p.product_id = src.product_surr_id
                 AND p.source_system = src.src_system
                 AND p.source_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET p.product_name = src.product_name,
            p.product_desc = src.product_desc,
            p.category_name = src.category_name,
            p.product_cost = src.product_cost,
            p.product_price = src.product_price,
            p.total_unit = src.total_unit,
            p.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            product_dm_surr_id,
            product_id,
            source_system,
            source_entity,
            product_name,
            product_desc,
            category_id,
            category_name,
            product_cost,
            product_price,
            total_unit,
            update_dt )
        VALUES
            ( bl_dm.products_id_seq_dm.nextval,
              src.product_surr_id,
              src.src_system,
              src.src_entity,
              src.product_name,
              src.product_desc,
              src.category_surr_id,
              src.category_name,
              src.product_cost,
              src.product_price,
              src.total_unit,
              current_date );

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
    END prc_dim_products;
    
-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE DIM_WAREHOUSES
    PROCEDURE prc_dim_warehouses IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DIM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_WAREHOUSES' );
        message      VARCHAR2(256) := ( 'DIM_WAREHOUSES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

--INSERT DATA
        MERGE INTO bl_dm.dim_warehouses w
        USING (
                  SELECT DISTINCT
                      warehouse_surr_id,
                      'BL_3NF'        AS src_system,
                      'CE_WAREHOUSES' AS src_entity,
                      warehouse_name,
                      a.address_surr_id,
                      address,
                      c.city_surr_id,
                      city,
                      ctr.country_surr_id,
                      country_code,
                      country_name,
                      r.region_surr_id,
                      region,
                      postal_code,
                      phone,
                      wh.update_dt
                  FROM
                      bl_3nf.ce_warehouses wh
                      LEFT JOIN bl_3nf.ce_addresses  a ON wh.address_surr_id = a.address_surr_id
                      LEFT JOIN bl_3nf.ce_cities     c ON a.city_surr_id = c.city_surr_id
                      LEFT JOIN bl_3nf.ce_countries  ctr ON c.country_surr_id = ctr.country_surr_id
                      LEFT JOIN bl_3nf.ce_regions    r ON ctr.region_surr_id = r.region_surr_id
                  WHERE
                      wh.warehouse_surr_id != - 1
              )
        src ON ( w.warehouse_id = src.warehouse_surr_id
                 AND w.source_system = src.src_system
                 AND w.source_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET w.warehouse_name = src.warehouse_name,
            w.address = src.address,
            w.city = src.city,
            w.country_code = src.country_code,
            w.country_name = src.country_name,
            w.region = src.region,
            w.phone = src.phone,
            w.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            warehouse_dm_surr_id,
            warehouse_id,
            source_system,
            source_entity,
            warehouse_name,
            address_id,
            address,
            city_id,
            city,
            country_id,
            country_code,
            country_name,
            region_id,
            region,
            postal_code,
            phone,
            update_dt )
        VALUES
            ( bl_dm.warehouses_id_seq_dm.nextval,
              src.warehouse_surr_id,
              src.src_system,
              src.src_entity,
              src.warehouse_name,
              src.address_surr_id,
              src.address,
              src.city_surr_id,
              src.city,
              src.country_surr_id,
              src.country_code,
              src.country_name,
              src.region_surr_id,
              src.region,
              src.postal_code,
              src.phone,
              current_date );

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
    END prc_dim_warehouses;

-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE DIM_ADDRESSES
    PROCEDURE prc_dim_addresses IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_ADDRESSES' );
        message      VARCHAR2(256) := ( 'DIM_ADDRESSES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

--INSERT DATA
        MERGE INTO bl_dm.dim_addresses ad
        USING (
                  SELECT DISTINCT
                      address_surr_id,
                      'BL_3NF'       AS src_system,
                      'CE_ADDRESSES' AS src_entity,
                      a.address,
                      c.city_surr_id,
                      city,
                      ctr.country_surr_id,
                      country_code,
                      country_name,
                      r.region_surr_id,
                      region,
                      postal_code,
                      phone,
                      a.update_dt
                  FROM
                      bl_3nf.ce_addresses a
                      LEFT JOIN bl_3nf.ce_cities    c ON a.city_surr_id = c.city_surr_id
                      LEFT JOIN bl_3nf.ce_countries ctr ON c.country_surr_id = ctr.country_surr_id
                      LEFT JOIN bl_3nf.ce_regions   r ON ctr.region_surr_id = r.region_surr_id
                  WHERE
                      a.address_surr_id != - 1
              )
        src ON ( ad.address_id = src.address_surr_id
                 AND ad.source_system = src.src_system
                 AND ad.source_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET ad.address = src.address,
            ad.city = src.city,
            ad.country_code = src.country_code,
            ad.country_name = src.country_name,
            ad.region = src.region,
            ad.phone = src.phone,
            ad.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            address_dm_surr_id,
            address_id,
            source_system,
            source_entity,
            address,
            city_id,
            city,
            country_id,
            country_code,
            country_name,
            region_id,
            region,
            postal_code,
            phone,
            update_dt )
        VALUES
            ( bl_dm.addresses_id_seq_dm.nextval,
              src.address_surr_id,
              src.src_system,
              src.src_entity,
              src.address,
              src.city_surr_id,
              src.city,
              src.country_surr_id,
              src.country_code,
              src.country_name,
              src.region_surr_id,
              src.region,
              src.postal_code,
              src.phone,
              current_date );

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
    END prc_dim_addresses;

--CREATE PROCEDURE TO INSERT DATA TO DIM_DISCOUNTS
    PROCEDURE prc_dim_discounts IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.DIM_DISCOUNTS' );
        message      VARCHAR2(256) := ( 'DIM_DISCOUNTS insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

--INSERT DATA
        MERGE INTO bl_dm.dim_discounts d
        USING (
                  SELECT DISTINCT
                      discount_surr_id,
                      'BL_3NF'       AS src_system,
                      'CE_DISCOUNTS' AS src_entity,
                      discount_title,
                      discount_percentage,
                      update_dt
                  FROM
                      bl_3nf.ce_discounts
                  WHERE
                      discount_surr_id != - 1
              )
        src ON ( d.discount_id = src.discount_surr_id
                 AND d.source_system = src.src_system
                 AND d.source_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET d.discount_title = src.discount_title,
            d.discount_percentage = src.discount_percentage,
            d.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            discount_dm_surr_id,
            discount_id,
            source_system,
            source_entity,
            discount_title,
            discount_percentage,
            update_dt )
        VALUES
            ( bl_dm.discounts_id_seq_dm.nextval,
              src.discount_surr_id,
              src.src_system,
              src.src_entity,
              src.discount_title,
              src.discount_percentage,
              current_date );

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
    END prc_dim_discounts;   
 
--CREATE PROCEDURE TO INSERT DATA TO DIM_PAYMENT_TYPES
    PROCEDURE prc_dim_payment_types AS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id              NUMBER := log_id_seq.nextval;
        process_name        VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table        VARCHAR2(256) := ( 'BL_DM.DIM_PAYMENT_TYPES' );
        message             VARCHAR2(256) := ( 'DIM_PAYMENT_TYPES insert' );
        user_name           VARCHAR2(256) := ( 'BL_CL' );
        user_win            VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date          TIMESTAMP(6) := current_date;
        end_date            TIMESTAMP(6) := NULL;
        row_count           NUMBER := 0;
        
--declare types and variables
        TYPE type_payment_type_id IS
            TABLE OF bl_3nf.ce_payment_types.payment_type_surr_id%TYPE INDEX BY PLS_INTEGER;
        TYPE type_payment_type IS
            TABLE OF bl_3nf.ce_payment_types.payment_type%TYPE INDEX BY PLS_INTEGER;
        TYPE type_paym_acccount IS
            TABLE OF bl_3nf.ce_payment_types.payment_account%TYPE INDEX BY PLS_INTEGER;
        var_payment_type_id type_payment_type_id;
        var_payment_type    type_payment_type;
        var_paym_acccount   type_paym_acccount;
        var_source_system   VARCHAR2(256) := 'BL_3NF';
        var_source_entity   VARCHAR2(256) := 'CE_PAYMENT_TYPES';
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.dim_payment_types';
        SELECT
            payment_type_surr_id,
            payment_type,
            payment_account
        BULK COLLECT
        INTO
            var_payment_type_id,
            var_payment_type,
            var_paym_acccount
        FROM
            bl_3nf.ce_payment_types
        WHERE
            bl_3nf.ce_payment_types.payment_type_surr_id != - 1;

        FORALL indx IN var_payment_type_id.first..var_payment_type_id.last
            INSERT INTO bl_dm.dim_payment_types (
                payment_type_dm_surr_id,
                payment_type_id,
                source_system,
                source_entity,
                payment_type,
                payment_account,
                update_dt
            ) VALUES (
                bl_dm.paym_types_id_seq_dm.nextval,
                var_payment_type_id(indx),
                var_source_system,
                var_source_entity,
                var_payment_type,
                var_paym_acccount,
                current_date
            );

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
    END prc_dim_payment_types;

-- --CREATE PROCEDURE FOR INCREMENTAL INSERTING DATA TO THE TABLE DIM_EMPLOYEES_SCD
    PROCEDURE prc_dim_employees_inc IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_EMPLOYEES_SCD' );
        message      VARCHAR2(256) := ( 'CE_EMPLOYEES_SCD insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_dm.dim_employees_scd emp
        USING ( SELECT
                  incr_employees.e_surr AS mergekey,
                  incr_employees.*
              FROM
                       incr_employees
                  JOIN bl_dm.dim_employees_scd emp ON incr_employees.e_surr = emp.employee_dm_surr_id
                                                      AND incr_employees.src_system = emp.source_system
                                                      AND incr_employees.src_entity = emp.source_entity
              WHERE
                      emp.current_flag = 'Y'
                  AND ( incr_employees.e_type != emp.employee_type )
              UNION ALL
              SELECT
                  NULL AS mergekey,
                  incr_employees.*
              FROM
                       incr_employees
                  JOIN bl_dm.dim_employees_scd emp ON incr_employees.e_surr = emp.employee_id
                                                      AND incr_employees.src_system = emp.source_system
                                                      AND incr_employees.src_entity = emp.source_entity
              WHERE
                      emp.current_flag = 'Y'
                  AND ( incr_employees.e_type <> emp.employee_type )
              )
        staged_updates ON ( emp.employee_id = mergekey
                            AND staged_updates.src_system = emp.source_system
                            AND staged_updates.src_entity = emp.source_entity )
        WHEN MATCHED THEN UPDATE
        SET current_flag = 'N',
            end_dt = current_date    -- Set current to false and endDate to source's effective date.            
        WHERE
                emp.current_flag = 'Y'
            AND ( emp.employee_type <> staged_updates.e_type
                  OR emp.personal_id <> staged_updates.p_id
                  OR emp.first_name <> staged_updates.f_name
                  OR emp.last_name <> staged_updates.l_name
                  OR emp.email <> staged_updates.mail
                  OR emp.address_id <> staged_updates.e_surr )
        WHEN NOT MATCHED THEN
        INSERT (
            employee_dm_surr_id,
            employee_id,
            source_system,
            source_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_id,
            address,
            city_id,
            city,
            country_id,
            country_code,
            country_name,
            region_id,
            region,
            postal_code,
            phone,
            employee_type,
            start_dt,
            end_dt,
            current_flag,
            update_dt )
        VALUES
            ( bl_dm.employees_id_seq_dm.nextval,
              staged_updates.e_surr,
              staged_updates.src_system,
              staged_updates.src_entity,
              staged_updates.p_id,
              staged_updates.f_name,
              staged_updates.l_name,
              staged_updates.mail,
              staged_updates.a_surr,
              staged_updates.addr,
              staged_updates.c_surr,
              staged_updates.cty,
              staged_updates.ctr_surr,
              staged_updates.c_code,
              staged_updates.c_name,
              staged_updates.r_surr,
              staged_updates.reg,
              staged_updates.p_code,
              staged_updates.p_hone,
              staged_updates.e_type,
              staged_updates.s_dt,
              staged_updates.e_dt,
              staged_updates.c_flag,
              current_date );
     
 --FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        UPDATE prm_mta_incremental_load
        SET
            previous_loaded_dt = current_date
        WHERE
            table_name = 'ce_emploees_scd';

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for ce_emploees_scd', user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_dim_employees_inc;

--CREATE PROCEDURE TO FIRST INSERT DATA TO FCT_PAYMENTS_DD
    PROCEDURE prc_fct_payments_dd IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.FCT_PAYMENTS_DD' );
        message      VARCHAR2(256) := ( 'FCT_PAYMENTS_DD insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_dm.fct_payments_dd';
--INSERT DATA
        INSERT INTO bl_dm.fct_payments_dd (
            payment_src_id,
            product_dm_surr_id,
            employee_dm_surr_id,
            warehouse_dm_surr_id,
            discount_dm_surr_id,
            address_dm_surr_id,
            customer_dm_surr_id,
            payment_type_dm_surr_id,
            product_cost,
            product_price,
            quantity,
            sale_date,
            day_id,
            update_dt
        )
            ( SELECT DISTINCT
                payment_src_id             AS a,
                p.product_dm_surr_id       AS b,
                e.employee_dm_surr_id      AS c,
                w.warehouse_dm_surr_id     AS d,
                d.discount_dm_surr_id      AS e,
                a.address_dm_surr_id       AS f,
                c.customer_dm_surr_id      AS g,
                pt.payment_type_dm_surr_id AS h,
                ce.product_cost            AS i,
                ce.product_price           AS j,
                ce.quantity                AS k,
                ce.sale_date               AS l,
                current_date               AS m,
                current_date               AS n
            FROM
                bl_3nf.ce_payments_dd   ce
                LEFT JOIN bl_dm.dim_products      p ON ce.product_surr_id = p.product_id
                LEFT JOIN bl_dm.dim_employees_scd e ON ce.employee_surr_id = e.employee_id 
--                            AND SALE_DATE >= start_dt 
                                                       AND sale_date < end_dt
                                                       AND e.source_system = 'BL_3NF'
                                                       AND e.source_entity = 'CE_EMPLOYEES_SCD'
                LEFT JOIN bl_dm.dim_warehouses    w ON ce.warehouse_surr_id = w.warehouse_id
                                                    AND w.source_system = 'BL_3NF'
                                                    AND w.source_entity = 'CE_WAREHOUSES'
                LEFT JOIN bl_dm.dim_addresses     a ON ce.address_surr_id = a.address_id
                                                   AND a.source_system = 'BL_3NF'
                                                   AND a.source_entity = 'CE_ADDRESSES'
                LEFT JOIN bl_dm.dim_discounts     d ON ce.discount_surr_id = d.discount_id
                                                   AND d.source_system = 'BL_3NF'
                                                   AND d.source_entity = 'CE_DISCOUNTS'
                LEFT JOIN bl_dm.dim_customers     c ON ce.customer_surr_id = c.customer_id
                LEFT JOIN bl_dm.dim_payment_types pt ON ce.payment_type_surr_id = pt.payment_type_id
--                LEFT JOIN bl_dm.dim_dates         ddt ON ddt.day_id = ce.sale_date
            );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_fct_payments_dd;

-- --CREATE PROCEDURE FOR INCREMENTAL INSERTING DATA TO THE TABLE FCT_PAYMENTS_DD
    PROCEDURE prc_fct_payments_inc IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.FCT_PAYMENTS_DD' );
        message      VARCHAR2(256) := ( 'FCT_PAYMENTS_DD insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN

--Partition exchange

        EXECUTE IMMEDIATE 'TRUNCATE TABLE incr_dm_payments';
        INSERT INTO bl_dm.fct_payments_dd (
            payment_src_id,
            product_dm_surr_id,
            employee_dm_surr_id,
            warehouse_dm_surr_id,
            discount_dm_surr_id,
            address_dm_surr_id,
            customer_dm_surr_id,
            payment_type_dm_surr_id,
            product_cost,
            product_price,
            quantity,
            sale_date,
            day_id,
            update_dt
        )
            ( SELECT DISTINCT
                payment_src_id             AS a,
                p.product_dm_surr_id       AS b,
                e.employee_dm_surr_id      AS c,
                w.warehouse_dm_surr_id     AS d,
                d.discount_dm_surr_id      AS e,
                a.address_dm_surr_id       AS f,
                c.customer_dm_surr_id      AS g,
                pt.payment_type_dm_surr_id AS h,
                ce.product_cost            AS i,
                ce.product_price           AS j,
                ce.quantity                AS k,
                ce.sale_date               AS l,
                current_date               AS m,
                current_date               AS n
            FROM
                bl_3nf.ce_payments_dd   ce
                LEFT JOIN bl_dm.dim_products      p ON ce.product_surr_id = p.product_id
                LEFT JOIN bl_dm.dim_employees_scd e ON ce.employee_surr_id = e.employee_id 
                            AND SALE_DATE >= start_dt 
                                                       AND sale_date < end_dt
                                                       AND e.source_system = 'BL_3NF'
                                                       AND e.source_entity = 'CE_EMPLOYEES_SCD'
                LEFT JOIN bl_dm.dim_warehouses    w ON ce.warehouse_surr_id = w.warehouse_id
                                                    AND w.source_system = 'BL_3NF'
                                                    AND w.source_entity = 'CE_WAREHOUSES'
                LEFT JOIN bl_dm.dim_addresses     a ON ce.address_surr_id = a.address_id
                                                   AND a.source_system = 'BL_3NF'
                                                   AND a.source_entity = 'CE_ADDRESSES'
                LEFT JOIN bl_dm.dim_discounts     d ON ce.discount_surr_id = d.discount_id
                                                   AND d.source_system = 'BL_3NF'
                                                   AND d.source_entity = 'CE_DISCOUNTS'
                LEFT JOIN bl_dm.dim_customers     c ON ce.customer_surr_id = c.customer_id
                LEFT JOIN bl_dm.dim_payment_types pt ON ce.payment_type_surr_id = pt.payment_type_id
                LEFT JOIN bl_dm.dim_dates         ddt ON ddt.day_id = ce.sale_date
            WHERE
--        c.update_dt > (select month_end_date from bl_dm.dim_dates where to_date(day_id, 'dd-mm-yyyy') = to_date(current_date, 'dd-mm-yyyy'))
                ce.sale_date > TO_DATE('28-02-22', 'dd-mm-yyyy')
            );

        EXECUTE IMMEDIATE 'ALTER TABLE BL_DM.FCT_PAYMENTS_DD EXCHANGE PARTITION p28 WITH table incr_dm_payments';

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        UPDATE prm_mta_incremental_load
        SET
            previous_loaded_dt = current_date
        WHERE
            table_name = 'ce_payments_dd';

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for ce_payments_dd', user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_fct_payments_inc;

END pkg_dm;

--EXECUTE pkg_dm.prc_dim_customers;
--EXECUTE pkg_dm.prc_dim_employees_scd;
--EXECUTE pkg_dm.prc_dim_products;
--EXECUTE pkg_dm.prc_dim_warehouses;
--EXECUTE pkg_dm.prc_dim_addresses;
--EXECUTE pkg_dm.prc_dim_discounts;
--EXECUTE pkg_dm.prc_dim_payment_types;
--EXECUTE pkg_dm.prc_fct_payments_dd;

--select * from bl_dm.fct_payments_dd;
--EXECUTE pkg_dm.prc_dim_customers_inc;
--EXECUTE pkg_dm.prc_dim_employees_inc;
--EXECUTE pkg_dm.prc_fct_payments_inc;