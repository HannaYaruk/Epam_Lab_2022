CREATE OR REPLACE PACKAGE BODY pkg_3nf AS

--CREATE PROCEDURE FOR INSERTING DATA TO prc_ce_payment_types TABLE
    PROCEDURE prc_ce_payment_types IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_PAYMENT_TYPES' );
        message      VARCHAR2(256) := ( 'CE_PAYMENT_TYPES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO bl_3nf.ce_payment_types p
        USING ( SELECT DISTINCT
                  nvl(id_paym_type, 'N/A') AS src_id,
                  'SA_SRC_BELG'            AS src_system,
                  'PAYM_TYPE_BELG_SRC'     AS src_entity,
                  nvl(paym_type, 'N/A')    AS p_type,
                  nvl(paym_acc, 'N/A')     AS p_acc,
                  current_date             AS dt
              FROM
                  sa_source_bel.paym_type_belg_src
              UNION ALL
              SELECT DISTINCT
                  nvl(id_paym_type, 'N/A') AS src_id,
                  'SA_SRC_FRA'             AS src_system,
                  'PAYM_TYPE_FRA_SRC'      AS src_entity,
                  nvl(paym_type, 'N/A')    AS p_type,
                  nvl(paym_acc, 'N/A')     AS p_acc,
                  current_date             AS dt
              FROM
                  sa_source_fra.paym_type_fra_src
              )
        src ON ( p.payment_type_src_id = src.src_id
                 AND p.source_src_system = src.src_system
                 AND p.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET p.payment_type = src.p_type,
            p.payment_account = src.p_acc,
            p.update_dt = current_date
        WHERE
            ( decode(p.payment_type, src.p_type, 0, 1) + decode(p.payment_account, src.p_acc, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            payment_type_surr_id,
            payment_type_src_id,
            source_src_system,
            source_src_entity,
            payment_type,
            payment_account,
            update_dt )
        VALUES
            ( paym_types_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.p_type,
            src.p_acc,
            dt );

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
    END prc_ce_payment_types;
    
 --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE ce_discounts
    PROCEDURE prc_ce_discounts IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_DISCOUNTS' );
        message      VARCHAR2(256) := ( 'CE_DISCOUNTS insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN

--DELETE ALL DATA TO REFRESH THE TABLE
        EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_payments_dd DISABLE CONSTRAINT fk_discount';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_discounts';
        EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_payments_dd ENABLE CONSTRAINT fk_discount';
        
--INSERT DATA - WE DON'T NEED TO MERGE IT
        INSERT INTO bl_3nf.ce_discounts (
            discount_surr_id,
            discount_src_id,
            source_src_system,
            source_src_entity,
            discount_title,
            discount_percentage,
            update_dt
        )
            ( SELECT
                bl_3nf.discounts_id_seq.nextval,
                nvl(id_disc, 'N/A'),
                'SA_SRC_BELG',
                'DISCOUNTS_SRC',
                nvl(title, 'N/A'),
                nvl((regexp_replace(percentage, '[^[[:digit:]]]*')), - 1),
                current_date
            FROM
                sa_source_bel.discounts_src
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
    END prc_ce_discounts;

 --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE CE_REGIONS
    PROCEDURE prc_ce_regions IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_REGIONS' );
        message      VARCHAR2(256) := ( 'CE_REGIONS insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_countries DISABLE CONSTRAINT fk_region_c';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_regions';
        EXECUTE IMMEDIATE 'ALTER TABLE bl_3nf.ce_countries ENABLE CONSTRAINT fk_region_c';
        
--INSERT DATA - WE DON'T NEED TO MERGE IT
        INSERT INTO bl_3nf.ce_regions (
            region_surr_id,
            region_src_id,
            source_src_system,
            source_src_entity,
            region,
            update_dt
        )
            SELECT
                regions_id_seq.NEXTVAL,
                a.*
            FROM
                (
                    SELECT DISTINCT
                        nvl(concat(structure_code, structure_desc), 'N/A'),
                        'SA_SRC_BELG',
                        'COUNTRY_REGIONS_SRC',
                        nvl(structure_desc, 'N/A'),
                        current_date
                    FROM
                        sa_source_bel.country_regions_src
                ) a;

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
    END prc_ce_regions;

 --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE CE_COUNTRIES
    PROCEDURE prc_ce_countries IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_COUNTRIES' );
        message      VARCHAR2(256) := ( 'CE_COUNTRIES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.ce_countries';
    
--INSERT DATA - WE DON'T NEED TO MERGE IT
        INSERT INTO bl_3nf.ce_countries (
            country_surr_id,
            country_src_id,
            source_src_system,
            source_src_entity,
            country_code,
            country_name,
            region_surr_id,
            update_dt
        )
            ( SELECT
                countries_id_seq.NEXTVAL,
                nvl(sh.country_id, 'N/A'),
                'SA_SRC_BELG',
                'COUNTRY_REGIONS_SRC',
                nvl(regexp_replace(sh.country_code, '[^[[:alpha:]]]*'), 'N/A'),
                nvl(sh.country_desc, 'N/A'),
                nvl(region_surr_id, - 1),
                current_date
            FROM
                     sa_source_bel.country_shortnames_src sh
                INNER JOIN sa_source_bel.country_regions_src rg ON sh.country_desc = rg.country_desc
                INNER JOIN bl_3nf.ce_regions                 cer ON cer.region = rg.structure_desc
            WHERE
                sh.country_desc NOT IN (
                    SELECT
                        country_name
                    FROM
                        bl_3nf.ce_countries
                )
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
    END prc_ce_countries;

-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE CE_CITIES
    PROCEDURE prc_ce_cities IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_CITIES' );
        message      VARCHAR2(256) := ( 'CE_CITIES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_3nf.ce_cities c
        USING ( SELECT DISTINCT
                  concat(city, ctr.country_name) AS src_id,
                  'SA_SRC_BELG'                  AS src_system,
                  'COUNTRY_REGIONS_SRC'          AS src_entity,
                  nvl(city, 'N/A')               AS city,
                  nvl(country_surr_id, - 1)      AS surr_id,
                  current_date                   AS dt
              FROM
                  sa_source_bel.emp_belg_src emp_b
                  LEFT JOIN bl_3nf.ce_countries        ctr ON ctr.country_name = emp_b.country_name
              UNION ALL
              SELECT DISTINCT
                  concat(city, ctr.country_name) AS src_id,
                  'SA_SRC_FRA'                   AS src_system,
                  'COUNTRY_REGIONS_SRC'          AS src_entity,
                  nvl(city, 'N/A')               AS city,
                  nvl(country_surr_id, - 1)      AS surr_id,
                  current_date                   AS dt
              FROM
                  sa_source_fra.emp_fra_src emp_f
                  LEFT JOIN bl_3nf.ce_countries       ctr ON ctr.country_name = emp_f.country_name
              UNION
              SELECT DISTINCT
                  concat(city, ctr.country_name) AS src_id,
                  'SA_SRC_BELG'                  AS src_system,
                  'COUNTRY_REGIONS_SRC'          AS src_entity,
                  nvl(city, 'N/A')               AS city,
                  nvl(country_surr_id, - 1)      AS surr_id,
                  current_date                   AS dt
              FROM
                  sa_source_bel.cust_belg_src cust_b
                  LEFT JOIN bl_3nf.ce_countries         ctr ON ctr.country_name = cust_b.country_name
              UNION
              SELECT DISTINCT
                  concat(city, ctr.country_name) AS src_id,
                  'SA_SRC_FRA'                   AS src_system,
                  'COUNTRY_REGIONS_SRC'          AS src_entity,
                  nvl(city, 'N/A')               AS city,
                  nvl(country_surr_id, - 1)      AS surr_id,
                  current_date                   AS dt
              FROM
                  sa_source_fra.cust_fra_src cust_f
                  LEFT JOIN bl_3nf.ce_countries        ctr ON ctr.country_name = cust_f.country_name
              UNION
              SELECT DISTINCT
                  concat(warehouse_city, warehouse_country_name) AS src_id,
                  'SA_SRC_BELG'                                  AS src_system,
                  'COUNTRY_REGIONS_SRC'                          AS src_entity,
                  nvl(warehouse_city, 'N/A')                     AS city,
                  nvl(country_surr_id, - 1)                      AS surr_id,
                  current_date                                   AS dt
              FROM
                  sa_source_bel.wareh_belg_src war_b
                  LEFT JOIN bl_3nf.ce_countries          ctr ON ctr.country_name = war_b.warehouse_country_name
              UNION
              SELECT DISTINCT
                  concat(warehouse_city, warehouse_country_name) AS src_id,
                  'SA_SRC_FRA'                                   AS src_system,
                  'COUNTRY_REGIONS_SRC'                          AS src_entity,
                  nvl(warehouse_city, 'N/A')                     AS city,
                  nvl(country_surr_id, - 1)                      AS surr_id,
                  current_date                                   AS dt
              FROM
                  sa_source_fra.wareh_fra_src war_f
                  LEFT JOIN bl_3nf.ce_countries         ctr ON ctr.country_name = war_f.warehouse_country_name
              )
        src ON ( c.city_src_id = src.src_id
                 AND c.source_src_system = src.src_system
                 AND c.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET c.city = src.city,
            c.country_surr_id = src.surr_id,
            update_dt = current_date
        WHERE
            ( decode(c.city, src.city, 0, 1) + decode(c.country_surr_id, src.surr_id, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            city_surr_id,
            city_src_id,
            source_src_system,
            source_src_entity,
            city,
            country_surr_id,
            update_dt )
        VALUES
            ( cities_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.city,
            src.surr_id,
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
    END prc_ce_cities;

-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE CE_ADDRESSES
    PROCEDURE prc_ce_addresses IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_ADDRESSES' );
        message      VARCHAR2(256) := ( 'CE_ADDRESSES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_3nf.ce_addresses a
        USING ( SELECT DISTINCT
                  concat(address, ct.city) AS src_id,
                  'SA_SRC_BELG'            AS src_system,
                  'EMP_BELG_SRC'           AS src_entity,
                  nvl(address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)   AS surr_id,
                  nvl(postal_code, 'N/A')  AS postal_code,
                  nvl(phone, 'N/A')        AS phn,
                  current_date             AS dt
              FROM
                  sa_source_bel.emp_belg_src emp_b
                  LEFT JOIN bl_3nf.ce_cities           ct ON ct.city = emp_b.city
                                                   AND ct.source_src_system = 'SA_SRC_BELG'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              UNION
              SELECT DISTINCT
                  concat(address, ct.city) AS src_id,
                  'SA_SRC_FRA'             AS src_system,
                  'EMP_FRA_SRC'            AS src_system,
                  nvl(address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)   AS surr_id,
                  nvl(postal_code, 'N/A')  AS postal_code,
                  nvl(phone, 'N/A')        AS phn,
                  current_date             AS dt
              FROM
                  sa_source_fra.emp_fra_src emp_f
                  LEFT JOIN bl_3nf.ce_cities          ct ON ct.city = emp_f.city
                                                   AND ct.source_src_system = 'SA_SRC_FRA'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              UNION
              SELECT DISTINCT
                  concat(address, ct.city) AS src_id,
                  'SA_SRC_BELG'            AS src_system,
                  'CUST_BELG_SRC'          AS src_system,
                  nvl(address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)   AS surr_id,
                  nvl(postal_code, 'N/A')  AS postal_code,
                  nvl(phone, 'N/A')        AS phn,
                  current_date             AS dt
              FROM
                  sa_source_bel.cust_belg_src cust_b
                  LEFT JOIN bl_3nf.ce_cities            ct ON ct.city = cust_b.city
                                                   AND ct.source_src_system = 'SA_SRC_BELG'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              UNION
              SELECT DISTINCT
                  concat(address, ct.city) AS src_id,
                  'SA_SRC_FRA'             AS src_system,
                  'CUST_FRA_SRC'           AS src_system,
                  nvl(address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)   AS surr_id,
                  nvl(postal_code, 'N/A')  AS postal_code,
                  nvl(phone, 'N/A')        AS phn,
                  current_date             AS dt
              FROM
                  sa_source_fra.cust_fra_src cust_f
                  LEFT JOIN bl_3nf.ce_cities           ct ON ct.city = cust_f.city
                                                   AND ct.source_src_system = 'SA_SRC_FRA'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              UNION
              SELECT DISTINCT
                  concat(warehouse_address, ct.city) AS src_id,
                  'SA_SRC_BELG'                      AS src_system,
                  'WAREH_BELG_SRC'                   AS src_system,
                  nvl(warehouse_address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)             AS surr_id,
                  nvl(warehouse_postal_code, 'N/A')  AS postal_code,
                  nvl(warehouse_phone, 'N/A')        AS phn,
                  current_date                       AS dt
              FROM
                  sa_source_bel.wareh_belg_src war_b
                  LEFT JOIN bl_3nf.ce_cities             ct ON ct.city = war_b.warehouse_city
                                                   AND ct.source_src_system = 'SA_SRC_BELG'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              UNION
              SELECT DISTINCT
                  concat(warehouse_address, ct.city) AS src_id,
                  'SA_SRC_FRA'                       AS src_system,
                  'WAREH_FRA_SRC'                    AS src_system,
                  nvl(warehouse_address, 'N/A')      AS address,
                  nvl(city_surr_id, - 1)             AS surr_id,
                  nvl(warehouse_postal_code, 'N/A')  AS postal_code,
                  nvl(warehouse_phone, 'N/A')        AS phn,
                  current_date                       AS dt
              FROM
                  sa_source_fra.wareh_fra_src war_f
                  LEFT JOIN bl_3nf.ce_cities            ct ON ct.city = war_f.warehouse_city
                                                   AND ct.source_src_system = 'SA_SRC_FRA'
                                                   AND ct.source_src_entity = 'COUNTRY_REGIONS_SRC'
              )
        src ON ( a.address_src_id = src.src_id
                 AND a.source_src_system = src.src_system
                 AND a.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET a.address = src.address,
            a.city_surr_id = src.surr_id,
            a.postal_code = src.postal_code,
            a.phone = src.phn,
            a.update_dt = current_date
        WHERE
            ( decode(a.address, src.address, 0, 1) + decode(a.city_surr_id, src.surr_id, 0, 1) + decode(a.postal_code, src.postal_code,
            0, 1) + decode(a.phone, src.phn, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            address_surr_id,
            address_src_id,
            source_src_system,
            source_src_entity,
            address,
            city_surr_id,
            postal_code,
            phone,
            update_dt )
        VALUES
            ( addresses_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.address,
            src.surr_id,
            src.postal_code,
            src.phn,
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
    END prc_ce_addresses;

-- --CREATE PROCEDURE FOR INSERTING DATA TO THE TABLE CE_CUSTOMERS
    PROCEDURE prc_ce_customers IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_CUSTOMERS' );
        message      VARCHAR2(256) := ( 'CE_CUSTOMERS insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_3nf.ce_customers c
        USING ( SELECT DISTINCT
                  nvl(id_cust, 'N/A')       AS src_id,
                  'SA_SRC_BELG'             AS src_system,
                  'CUST_BELG_SRC'           AS src_entity,
                  nvl(personal_id, 'N/A')   AS personal_id,
                  nvl(first_name, 'N/A')    AS first_name,
                  nvl(last_name, 'N/A')     AS last_name,
                  'N/A'                     AS email,
                  nvl(address_surr_id, - 1) AS surr_id,
                  current_date              AS dt
              FROM
                  sa_source_bel.cust_belg_src b
                  LEFT JOIN bl_3nf.ce_addresses         a ON b.address = a.address
              UNION ALL
              SELECT DISTINCT
                  nvl(id_cust, 'N/A')       AS src_id,
                  'SA_SRC_FRA'              AS src_system,
                  'CUST_FRA_SRC'            AS src_entity,
                  personal_id               AS personal_id,
                  nvl(first_name, 'N/A')    AS first_name,
                  nvl(last_name, 'N/A')     AS last_name,
                  nvl(email, 'N/A')         AS email,
                  nvl(address_surr_id, - 1) AS surr_id,
                  current_date              AS dt
              FROM
                  sa_source_fra.cust_fra_src f
                  LEFT JOIN bl_3nf.ce_addresses        a ON f.address = a.address
              )
        src ON ( c.customer_src_id = src.src_id
                 AND c.source_src_system = src.src_system
                 AND c.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET c.personal_id = src.personal_id,
            c.first_name = src.first_name,
            c.last_name = src.last_name,
            c.email = src.email,
            c.address_surr_id = src.surr_id,
            c.update_dt = current_date
        WHERE
            ( decode(c.personal_id, src.personal_id, 0, 1) + decode(c.first_name, src.first_name, 0, 1) + decode(c.last_name, src.last_name,
            0, 1) + decode(c.email, src.email, 0, 1) + decode(c.address_surr_id, src.surr_id, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            customer_surr_id,
            customer_src_id,
            source_src_system,
            source_src_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_surr_id,
            update_dt )
        VALUES
            ( customers_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.email,
            src.surr_id,
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
    END prc_ce_customers;

-- --CREATE PROCEDURE FOR FIRST INSERTING DATA TO THE TABLE CE_EMPLOYEES_SCD
    PROCEDURE prc_ce_employees IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_EMPLOYEES_SCD' );
        message      VARCHAR2(256) := ( 'CE_EMPLOYEES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_3nf.ce_employees_scd e
        USING ( SELECT DISTINCT
                  nvl(id_emp, 'N/A')                               AS src_id,
                  'SA_SRC_BELG'                                    AS src_system,
                  'EMP_BELG_SRC'                                   AS src_entity,
                  nvl(personal_id, 'N/A')                          AS personal_id,
                  nvl(first_name, 'N/A')                           AS first_name,
                  nvl(last_name, 'N/A')                            AS last_name,
                  nvl(email, 'N/A')                                AS email,
                  nvl(address_surr_id, - 1)                        AS surr_id,
                  nvl(emp_type, 'N/A')                             AS emp_type,
                  TO_DATE('01-01-1900', 'DD-MM-YYYY')              AS start_dt,
                  to_date(nvl(end_dt, '31-12-9999'), 'DD-MM-YYYY') AS end_dt,
                  nvl(curr_flag, 'Y')                              AS curr_flag,
                  current_date                                     AS dt
              FROM
                  sa_source_bel.emp_belg_src b
                  LEFT JOIN bl_3nf.ce_addresses        a ON b.address = a.address
              UNION ALL
              SELECT DISTINCT
                  nvl(id_emp, 'N/A')                               AS src_id,
                  'SA_SRC_FRA'                                     AS src_system,
                  'EMP_FRA_SRC'                                    AS src_entity,
                  nvl(personal_id, 'N/A')                          AS personal_id,
                  nvl(first_name, 'N/A')                           AS first_name,
                  nvl(last_name, 'N/A')                            AS last_name,
                  nvl(email, 'N/A')                                AS email,
                  nvl(address_surr_id, - 1)                        AS surr_id,
                  nvl(emp_type, 'N/A')                             AS emp_type,
                  TO_DATE('01-01-1900', 'DD-MM-YYYY')              AS start_dt,
                  to_date(nvl(end_dt, '31-12-9999'), 'DD-MM-YYYY') AS end_dt,
                  nvl(curr_flag, 'Y')                              AS curr_flag,
                  current_date                                     AS dt
              FROM
                  sa_source_fra.emp_fra_src f
                  LEFT JOIN bl_3nf.ce_addresses       a ON f.address = a.address
              )
        src ON ( e.employee_src_id = src.src_id
                 AND e.source_src_system = src.src_system
                 AND e.source_src_entity = src.src_entity
                 AND e.start_dt = src.start_dt )
        WHEN MATCHED THEN UPDATE
        SET e.personal_id = src.personal_id,
            e.first_name = src.first_name,
            e.last_name = src.last_name,
            e.email = src.email,
            e.address_surr_id = src.surr_id,
            e.employee_type = src.emp_type,
            e.end_dt = src.end_dt,
            e.current_flag = src.curr_flag,
            e.update_dt = current_date
        WHEN NOT MATCHED THEN
        INSERT (
            employee_surr_id,
            employee_src_id,
            source_src_system,
            source_src_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_surr_id,
            employee_type,
            start_dt,
            end_dt,
            current_flag,
            update_dt )
        VALUES
            ( employees_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.email,
            src.surr_id,
            src.emp_type,
            src.start_dt,
            src.end_dt,
            src.curr_flag,
            current_date );

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

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
            'emp_belg_src',
            'ce_employees_scd',
            'pkg_3nf',
            'prc_ce_employees',
            current_date
        );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for emp_belg_src', user_name,
               user_win, start_date, end_date, row_count);

        INSERT INTO prm_mta_incremental_load (
            table_name,
            target_table_name,
            package_ttl,
            procedure_ttl,
            previous_loaded_dt
        ) VALUES (
            'emp_fra_src',
            'ce_employees_scd',
            'pkg_3nf',
            'prc_ce_employees',
            current_date
        );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for emp_fra_src', user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_ce_employees;

--CREATE PROCEDURE FOR INSERTING DATA TO CE_WAREHOUSES TABLE
    PROCEDURE prc_ce_warehouses IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_WAREHOUSES' );
        message      VARCHAR2(256) := ( 'CE_WAREHOUSES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
    
--MERGE DATA
        MERGE INTO bl_3nf.ce_warehouses w
        USING ( SELECT DISTINCT
                  nvl(warehouse_id, 'N/A')                                      AS src_id,
                  'SA_SRC_BELG'                                                 AS src_system,
                  'WAREH_BELG_SRC'                                              AS src_entity,
                  nvl(warehouse_name, 'N/A')                                    AS wname,
                  nvl(address_surr_id, - 1)                                     AS surr_id,
                  nvl(to_number(regexp_replace(total, '[^[[:digit:]]]*')), - 1) AS total,
                  current_date                                                  AS dt
              FROM
                  sa_source_bel.wareh_belg_src b
                  LEFT JOIN bl_3nf.ce_addresses          a ON concat(b.warehouse_address, b.warehouse_city) = a.address_src_id
              UNION ALL
              SELECT DISTINCT
                  nvl(warehouse_id, 'N/A')                                      AS src_id,
                  'SA_SRC_FRA'                                                  src_system,
                  'WAREH_FRA_SRC'                                               AS src_entity,
                  nvl(warehouse_name, 'N/A')                                    AS wname,
                  nvl(address_surr_id, - 1)                                     AS surr_id,
                  nvl(to_number(regexp_replace(total, '[^[[:digit:]]]*')), - 1) AS total,
                  current_date                                                  AS dt
              FROM
                  sa_source_fra.wareh_fra_src f
                  LEFT JOIN bl_3nf.ce_addresses         a ON concat(f.warehouse_address, f.warehouse_city) = a.address_src_id
              )
        src ON ( w.warehouse_src_id = src.src_id
                 AND w.source_src_system = src.src_system
                 AND w.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET w.warehouse_name = src.wname,
            w.address_surr_id = src.surr_id,
            w.total_positions = src.total,
            w.update_dt = current_date
        WHERE
            decode(w.warehouse_name, src.wname, 0, 1) + decode(w.address_surr_id, src.surr_id, 0, 1) + decode(w.total_positions, src.
            total, 0, 1) > 0
        WHEN NOT MATCHED THEN
        INSERT (
            warehouse_surr_id,
            warehouse_src_id,
            source_src_system,
            source_src_entity,
            warehouse_name,
            address_surr_id,
            total_positions,
            update_dt )
        VALUES
            ( warehouses_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.wname,
            src.surr_id,
            src.total,
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
    END prc_ce_warehouses;

--CREATE PROCEDURE FOR INSERTING DATA TO CE_CATEGORIES TABLE
    PROCEDURE prc_ce_categories IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_CATEGORIES' );
        message      VARCHAR2(256) := ( 'CE_CATEGORIES insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

--truncate table bl_3nf.ce_categories;
--MERGE DATA
        MERGE INTO bl_3nf.ce_categories c
        USING ( SELECT DISTINCT
                  nvl(concat(category_name, warehouse_country_code), 'N/A') src_id,
                  'SA_SRC_BELG'                                             AS src_system,
                  'PROD_BELG_SRC'                                           AS src_entity,
                  nvl(category_name, 'N/A')                                 AS cname,
                  current_date                                              AS dt
              FROM
                  sa_source_bel.prod_belg_src
              UNION ALL
              SELECT DISTINCT
                  nvl(concat(category_name, warehouse_country_code), 'N/A') src_id,
                  'SA_SRC_FRA'                                              src_system,
                  'PROD_FRA_SRC'                                            src_entity,
                  nvl(category_name, 'N/A')                                 AS cname,
                  current_date                                              AS dt
              FROM
                  sa_source_fra.prod_fra_src
              )
        src ON ( c.category_src_id = src.src_id
                 AND c.source_src_system = src.src_system
                 AND c.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET c.category_name = src.cname,
            c.update_dt = current_date
        WHERE
            c.category_name != src.cname
        WHEN NOT MATCHED THEN
        INSERT (
            category_surr_id,
            category_src_id,
            source_src_system,
            source_src_entity,
            category_name,
            update_dt )
        VALUES
            ( categories_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.cname,
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
    END prc_ce_categories;

--CREATE PROCEDURE FOR INSERTING DATA TO CE_PRODUCTS TABLE
    PROCEDURE prc_ce_products IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_PRODUCTS' );
        message      VARCHAR2(256) := ( 'CE_PRODUCTS inserted' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN

    
--MERGE DATA
        MERGE INTO bl_3nf.ce_products p
        USING ( SELECT DISTINCT
                  nvl(product_id, 'N/A')                                                AS src_id,
                  'SA_SRC_BELG'                                                         AS src_system,
                  'PROD_BELG_SRC'                                                       AS src_entity,
                  nvl(product_name, 'N/A')                                              AS pname,
                  nvl(product_desc, 'N/A')                                              AS pdesc,
                  nvl(category_surr_id, - 1)                                            AS c_surr_id,
                  nvl(to_number(regexp_replace(product_cost, '[^[[:digit:]]]*')), - 1)  AS pcost,
                  nvl(to_number(regexp_replace(product_price, '[^[[:digit:]]]*')), - 1) AS price,
                  nvl(warehouse_surr_id, - 1)                                           AS w_surr_id,
                  nvl(to_number(regexp_replace(total, '[^[[:digit:]]]*')), - 1)         AS total,
                  current_date                                                          AS dt
              FROM
                  sa_source_bel.prod_belg_src prod
                  LEFT JOIN bl_3nf.ce_categories        cat ON prod.category_name = cat.category_name
                                                        AND cat.source_src_system = 'SA_SRC_BELG'
                  LEFT JOIN bl_3nf.ce_warehouses        w ON prod.warehouse_id = w.warehouse_src_id
                                                      AND w.source_src_system = 'SA_SRC_BELG'
              WHERE
                      prod.warehouse_country_code = 'BE'
                  AND cat.source_src_system = 'SA_SRC_BELG'
                  AND w.source_src_system = 'SA_SRC_BELG'
              UNION ALL
              SELECT DISTINCT
                  nvl(product_id, 'N/A')                                                AS src_id,
                  'SA_SRC_FRA'                                                          AS src_system,
                  'PROD_FRA_SRC'                                                        AS src_entity,
                  nvl(product_name, 'N/A')                                              AS pname,
                  nvl(product_desc, 'N/A')                                              AS pdesc,
                  nvl(category_surr_id, - 1)                                            AS c_surr_id,
                  nvl(to_number(regexp_replace(product_cost, '[^[[:digit:]]]*')), - 1)  AS pcost,
                  nvl(to_number(regexp_replace(product_price, '[^[[:digit:]]]*')), - 1) AS price,
                  nvl(warehouse_surr_id, - 1)                                           AS w_surr_id,
                  nvl(to_number(regexp_replace(total, '[^[[:digit:]]]*')), - 1)         AS total,
                  current_date                                                          AS dt
              FROM
                  sa_source_fra.prod_fra_src prod2
                  LEFT JOIN bl_3nf.ce_categories       cat ON prod2.category_name = cat.category_name
                                                        AND cat.source_src_system = 'SA_SRC_FRA'
                  LEFT JOIN bl_3nf.ce_warehouses       w ON prod2.warehouse_id = w.warehouse_src_id
                                                      AND w.source_src_system = 'SA_SRC_FRA'
              WHERE
                      prod2.warehouse_country_code = 'FR'
                  AND cat.source_src_system = 'SA_SRC_FRA'
                  AND w.source_src_system = 'SA_SRC_FRA'
              )
        src ON ( p.product_src_id = src.src_id
                 AND p.source_src_system = src.src_system
                 AND p.source_src_entity = src.src_entity )
        WHEN MATCHED THEN UPDATE
        SET p.product_name = src.pname,
            p.product_desc = src.pdesc,
            p.category_surr_id = src.c_surr_id,
            p.product_cost = src.pcost,
            p.product_price = src.price,
            p.warehouse_surr_id = src.w_surr_id,
            p.total_unit = src.total,
            p.update_dt = current_date
        WHERE
            decode(p.product_name, src.pname, 0, 1) + decode(p.product_desc, src.pdesc, 0, 1) + decode(p.category_surr_id, src.c_surr_id,
            0, 1) + decode(p.product_cost, src.pcost, 0, 1) + decode(p.product_price, src.price, 0, 1) + decode(p.warehouse_surr_id, src.
            w_surr_id, 0, 1) + decode(p.total_unit, src.total, 0, 1) > 0
        WHEN NOT MATCHED THEN
        INSERT (
            product_surr_id,
            product_src_id,
            source_src_system,
            source_src_entity,
            product_name,
            product_desc,
            category_surr_id,
            product_cost,
            product_price,
            warehouse_surr_id,
            total_unit,
            update_dt )
        VALUES
            ( products_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.pname,
            src.pdesc,
            src.c_surr_id,
            src.pcost,
            src.price,
            src.w_surr_id,
            src.total,
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
    END prc_ce_products;

--CREATE PROCEDURE FOR INSERTING DATA TO CE_PAYMENTS_DD TABLE
    PROCEDURE prc_ce_payments_dd IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_PAYMENTS_DD' );
        message      VARCHAR2(256) := ( 'CE_PAYMENTS_DD insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP(6) := current_date;
        end_date     TIMESTAMP(6) := NULL;
        row_count    NUMBER := 0;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE bl_3nf.CE_PAYMENTS_DD';
    
--INSERT DATA
        INSERT INTO bl_3nf.ce_payments_dd (
            employee_surr_id,
            warehouse_surr_id,
            address_surr_id,
            payment_type_surr_id,
            customer_surr_id,
            product_surr_id,
            discount_surr_id,
            quantity,
            sale_date,
            payment_src_id,
            product_cost,
            product_price,
            update_dt
        )
            SELECT DISTINCT
                nvl(employee_surr_id, - 1),
                nvl(w.warehouse_surr_id, - 1),
                nvl(a.address_surr_id, - 1),
                nvl(payment_type_surr_id, - 1),
                nvl(customer_surr_id, - 1),
                nvl(product_surr_id, - 1),
                nvl(discount_surr_id, - 1),
                nvl(to_number(quantity), - 1),
                to_date(nvl(sale_date, '31-12-9999'), 'DD-MM-YYYY'),
                nvl(to_number(payment_id), - 1),
                nvl(p.product_cost, - 1),
                nvl(p.product_price, - 1),
                current_date
            FROM
                sa_source_bel.payment_belg_src sr
                LEFT JOIN bl_3nf.ce_employees_scd        e ON sr.employee_id = e.employee_src_id
                                                       AND sale_date >= start_dt
                                                       AND sale_date < end_dt
                                                       AND e.source_src_system = 'SA_SRC_BELG'
                                                       AND e.source_src_entity = 'EMP_BELG_SRC'
                LEFT JOIN bl_3nf.ce_warehouses           w ON sr.warehouse_id = w.warehouse_src_id
                                                    AND w.source_src_system = 'SA_SRC_BELG'
                                                    AND w.source_src_entity = 'WAREH_BELG_SRC'
                LEFT JOIN bl_3nf.ce_addresses            a ON w.address_surr_id = a.address_surr_id
                                                   AND a.source_src_system = 'SA_SRC_BELG'
                                                   AND a.source_src_entity = 'WAREH_BELG_SRC'
                LEFT JOIN bl_3nf.ce_payment_types        pt ON sr.payment_type_id = pt.payment_type_src_id
                                                        AND pt.source_src_system = 'SA_SRC_BELG'
                                                        AND pt.source_src_entity = 'PAYM_TYPE_BELG_SRC'
                LEFT JOIN bl_3nf.ce_customers            c ON sr.customer_id = c.customer_src_id
                                                   AND c.source_src_system = 'SA_SRC_BELG'
                                                   AND c.source_src_entity = 'CUST_BELG_SRC'
                LEFT JOIN bl_3nf.ce_products             p ON sr.product_id = p.product_src_id
                                                  AND p.source_src_system = 'SA_SRC_BELG'
                                                  AND p.source_src_entity = 'PROD_BELG_SRC'
                LEFT JOIN bl_3nf.ce_discounts            d ON sr.discount_id = d.discount_src_id
                                                   AND d.source_src_system = 'SA_SRC_BELG'
                                                   AND d.source_src_entity = 'DISCOUNTS_SRC'
            UNION ALL
            SELECT DISTINCT
                nvl(employee_surr_id, - 1),
                nvl(wf.warehouse_surr_id, - 1),
                nvl(af.address_surr_id, - 1),
                nvl(payment_type_surr_id, - 1),
                nvl(customer_surr_id, - 1),
                nvl(product_surr_id, - 1),
                nvl(discount_surr_id, - 1),
                nvl(to_number(quantity), - 1),
                to_date(nvl(sale_date, '31-12-9999'), 'DD-MM-YYYY'),
                nvl(to_number(payment_id), - 1),
                nvl(to_number(product_cost), - 1),
                nvl(to_number(product_price), - 1),
                current_date
            FROM
                sa_source_fra.payment_fra_src srf
                LEFT JOIN bl_3nf.ce_employees_scd       ef ON srf.employee_id = ef.employee_src_id
                                                        AND sale_date >= start_dt
                                                        AND sale_date < end_dt
                                                        AND ef.source_src_system = 'SA_SRC_FRA'
                                                        AND ef.source_src_entity = 'EMP_FRA_SRC'
                LEFT JOIN bl_3nf.ce_warehouses          wf ON srf.warehouse_id = wf.warehouse_src_id
                                                     AND wf.source_src_system = 'SA_SRC_FRA'
                                                     AND wf.source_src_entity = 'WAREH_FRA_SRC'
                LEFT JOIN bl_3nf.ce_addresses           af ON wf.address_surr_id = af.address_surr_id
                                                    AND af.source_src_system = 'SA_SRC_FRA'
                                                    AND af.source_src_entity = 'WAREH_FRA_SRC'
                LEFT JOIN bl_3nf.ce_payment_types       ptf ON srf.payment_type_id = ptf.payment_type_src_id
                                                         AND ptf.source_src_system = 'SA_SRC_FRA'
                                                         AND ptf.source_src_entity = 'PAYM_TYPE_FRA_SRC'
                LEFT JOIN bl_3nf.ce_customers           cf ON srf.customer_id = cf.customer_src_id
                                                    AND cf.source_src_system = 'SA_SRC_FRA'
                                                    AND cf.source_src_entity = 'CUST_FRA_SRC'
                LEFT JOIN bl_3nf.ce_products            pf ON srf.product_id = pf.product_src_id
                                                   AND pf.source_src_system = 'SA_SRC_FRA'
                                                   AND pf.source_src_entity = 'PROD_FRA_SRC'
                                                   AND pf.source_src_system = 'SA_SRC_FRA'
                LEFT JOIN bl_3nf.ce_discounts           df ON srf.discount_id = df.discount_src_id
                                                    AND df.source_src_system = 'SA_SRC_BELG'
                                                    AND df.source_src_entity = 'DISCOUNTS_SRC';

--FILL NEEDED FIELDS OF LOG TABLE - COUNT ROWS AND FILL END DATETIME. 
--CALL LOG PROCEDURE

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
            'payment_belg_src',
            'ce_payments_dd',
            'pkg_3nf',
            'prc_ce_payments_dd',
            current_date
        );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for payment_belg_src', user_name,
               user_win, start_date, end_date, row_count);

        INSERT INTO prm_mta_incremental_load (
            table_name,
            target_table_name,
            package_ttl,
            procedure_ttl,
            previous_loaded_dt
        ) VALUES (
            'payment_fra_src',
            'ce_payments_dd',
            'pkg_3nf',
            'prc_ce_payments_dd',
            current_date
        );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for payment_fra_src', user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_ce_payments_dd;

-- --CREATE PROCEDURE FOR INCREMENTAL INSERTING DATA TO THE TABLE CE_EMPLOYEES_SCD
    PROCEDURE prc_ce_employees_inc IS

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

--Update changed positions
        MERGE INTO bl_3nf.ce_employees_scd emp
        USING (
   -- These rows will either UPDATE the current addresses of existing customers or INSERT the new addresses of new customers
         SELECT
                  incr_employees.src_id AS mergekey,
                  incr_employees.*
              FROM
                       incr_employees
                  JOIN bl_3nf.ce_employees_scd emp ON incr_employees.src_id = emp.employee_src_id
                                                      AND incr_employees.src_system = emp.source_src_system
                                                      AND incr_employees.src_entity = emp.source_src_entity
              WHERE
                      emp.current_flag = 'Y'
                  AND ( incr_employees.emp_type != emp.employee_type )
              UNION ALL
              SELECT
                  NULL AS mergekey,
                  incr_employees.*
              FROM
                       incr_employees
                  JOIN bl_3nf.ce_employees_scd emp ON incr_employees.src_id = emp.employee_src_id
                                                      AND incr_employees.src_system = emp.source_src_system
                                                      AND incr_employees.src_entity = emp.source_src_entity
              WHERE
                      emp.current_flag = 'Y'
                  AND ( incr_employees.emp_type <> emp.employee_type )
              )
        staged_updates ON ( emp.employee_src_id = mergekey
                            AND staged_updates.src_system = emp.source_src_system
                            AND staged_updates.src_entity = emp.source_src_entity )
        WHEN MATCHED THEN UPDATE
        SET current_flag = 'N',
            end_dt = current_date    -- Set current to false and endDate to source's effective date.            
        WHERE
                emp.current_flag = 'Y'
            AND ( emp.employee_type <> staged_updates.emp_type
                  OR emp.personal_id <> staged_updates.personal_id
                  OR emp.first_name <> staged_updates.first_name
                  OR emp.last_name <> staged_updates.last_name
                  OR emp.email <> staged_updates.email
                  OR emp.address_surr_id <> staged_updates.surr_id )
        WHEN NOT MATCHED THEN
        INSERT (
            employee_surr_id,
            employee_src_id,
            source_src_system,
            source_src_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_surr_id,
            employee_type,
            start_dt,
            end_dt,
            current_flag,
            update_dt )
        VALUES
            ( employees_id_seq.NEXTVAL,
            staged_updates.src_id,
            staged_updates.src_system,
            staged_updates.src_entity,
            staged_updates.personal_id,
            staged_updates.first_name,
            staged_updates.last_name,
            staged_updates.email,
            staged_updates.surr_id,
            staged_updates.emp_type,
            staged_updates.start_dt,
            staged_updates.end_dt,
            staged_updates.curr_flag,
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
            table_name = 'emp_belg_src';

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for emp_belg_src', user_name,
               user_win, start_date, end_date, row_count);

        UPDATE prm_mta_incremental_load
        SET
            previous_loaded_dt = current_date
        WHERE
            table_name = 'emp_fra_src';

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, 'mta_incremental_load', 'mta_incremental_load', 'MTA is loaded for emp_fra_src', user_name,
               user_win, start_date, end_date, row_count);
               
               
--Insert new data not in ce_employees_scd
        MERGE INTO bl_3nf.ce_employees_scd e
        USING (
                  SELECT
                      src_id,
                      src_system,
                      src_entity,
                      personal_id,
                      first_name,
                      last_name,
                      email,
                      surr_id,
                      emp_type,
                      start_dt,
                      end_dt,
                      curr_flag,
                      dt
                  FROM
                      incr_employees
              )
        src ON ( e.employee_src_id = src.src_id
                 AND e.source_src_system = src.src_system
                 AND e.source_src_entity = src.src_entity
                 AND e.start_dt = src.start_dt )
        WHEN NOT MATCHED THEN
        INSERT (
            employee_surr_id,
            employee_src_id,
            source_src_system,
            source_src_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_surr_id,
            employee_type,
            start_dt,
            end_dt,
            current_flag,
            update_dt )
        VALUES
            ( employees_id_seq.NEXTVAL,
            src.src_id,
            src.src_system,
            src.src_entity,
            src.personal_id,
            src.first_name,
            src.last_name,
            src.email,
            src.surr_id,
            src.emp_type,
            src.start_dt,
            src.end_dt,
            src.curr_flag,
            current_date );

        row_count := SQL%rowcount;
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_ce_employees_inc;

-- --CREATE PROCEDURE FOR INCREMENTAL INSERTING DATA TO THE TABLE CE_PAYMENTS_DD
    PROCEDURE prc_ce_payments_inc IS

--DECLARE THE FIELDS THAT WILL BE INSERTED INTO LOG TABLE
        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.CE_PAYMENTS_DD' );
        message      VARCHAR2(256) := ( 'CE_PAYMENTS_DD insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        MERGE INTO bl_3nf.ce_payments_dd p
        USING (
                  SELECT
                      *
                  FROM
                      incr_payments
              )
        src ON ( p.employee_surr_id = src.e_id
                 AND p.warehouse_surr_id = src.w_id
                 AND p.address_surr_id = src.a_id
                 AND p.payment_type_surr_id = src.pt_id
                 AND p.customer_surr_id = src.c_id
                 AND p.product_surr_id = src.p_id
                 AND p.discount_surr_id = src.d_id
                 AND p.payment_src_id = src.py_id )
        WHEN MATCHED THEN UPDATE
        SET p.quantity = src.q_id,
            p.product_cost = src.pc,
            p.product_price = src.pp,
            p.sale_date = src.sd,
            p.update_dt = current_date
        WHERE
            ( decode(p.quantity, src.q_id, 0, 1) + decode(p.product_cost, src.pc, 0, 1) + decode(p.product_price, src.pp, 0, 1) + decode(
            p.sale_date, p.sale_date, 0, 1) > 0 )
        WHEN NOT MATCHED THEN
        INSERT (
            employee_surr_id,
            warehouse_surr_id,
            address_surr_id,
            payment_type_surr_id,
            customer_surr_id,
            product_surr_id,
            discount_surr_id,
            quantity,
            sale_date,
            payment_src_id,
            product_cost,
            product_price,
            update_dt )
        VALUES
            ( src.e_id,
              src.w_id,
              src.a_id,
              src.pt_id,
              src.c_id,
              src.p_id,
              src.d_id,
              src.q_id,
              src.sd,
              src.py_id,
              src.pc,
              src.pp,
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
    END prc_ce_payments_inc;

END pkg_3nf;

--EXECUTE pkg_3nf.prc_init
--EXECUTE pkg_3nf.prc_ce_payment_types;
--EXECUTE pkg_3nf.prc_ce_discounts;
--EXECUTE pkg_3nf.prc_ce_regions;
--EXECUTE pkg_3nf.prc_ce_countries;
--EXECUTE pkg_3nf.prc_ce_cities;
--EXECUTE pkg_3nf.prc_ce_addresses;
--EXECUTE pkg_3nf.prc_ce_customers;
--EXECUTE pkg_3nf.prc_ce_employees;
--EXECUTE pkg_3nf.prc_ce_warehouses;
--EXECUTE pkg_3nf.prc_ce_categories;
--EXECUTE pkg_3nf.prc_ce_products;
--EXECUTE pkg_3nf.prc_ce_payments_dd;

--SELECT * FROM BL_3NF.ce_payments_dd;
--Procedures for incremental load
--EXECUTE pkg_3nf.prc_ce_employees_inc;
--EXECUTE pkg_3nf.prc_ce_payments_inc;