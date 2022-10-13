--Create procedure to insert default init rows
   CREATE or replace PROCEDURE prc_init IS

        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( '3NF_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_3NF.ALL_tables' );
        message      VARCHAR2(256) := ( 'INIT_tables insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        INSERT INTO bl_3nf.ce_payment_types (
            payment_type_surr_id,
            payment_type_src_id,
            source_src_system,
            source_src_entity,
            payment_type,
            payment_account,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_discounts (
            discount_surr_id,
            discount_src_id,
            source_src_system,
            source_src_entity,
            discount_title,
            discount_percentage,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_regions (
            region_surr_id,
            region_src_id,
            source_src_system,
            source_src_entity,
            region,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_countries (
            country_surr_id,
            country_src_id,
            source_src_system,
            source_src_entity,
            country_code,
            country_name,
            region_surr_id,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_cities (
            city_surr_id,
            city_src_id,
            source_src_system,
            source_src_entity,
            city,
            country_surr_id,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_addresses (
            address_surr_id,
            address_src_id,
            source_src_system,
            source_src_entity,
            address,
            city_surr_id,
            postal_code,
            phone,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_customers (
            customer_surr_id,
            customer_src_id,
            source_src_system,
            source_src_entity,
            personal_id,
            first_name,
            last_name,
            email,
            address_surr_id,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_employees_scd (
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
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY'),
            TO_DATE('31-12-9999', 'DD-MM-YYYY'),
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_warehouses (
            warehouse_surr_id,
            warehouse_src_id,
            source_src_system,
            source_src_entity,
            warehouse_name,
            address_surr_id,
            total_positions,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_categories (
            category_surr_id,
            category_src_id,
            source_src_system,
            source_src_entity,
            category_name,
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
       row_count := row_count + 1;
        INSERT INTO bl_3nf.ce_products (
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
            update_dt
        ) VALUES (
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            - 1,
            - 1,
            - 1,
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
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
        ) VALUES (
            - 1,
            - 1,
            - 1,
            - 1,
            - 1,
            - 1,
            - 1,
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY'),
            - 1,
            - 1,
            - 1,
            TO_DATE('31-12-9999', 'DD-MM-YYYY')
        );

        row_count := row_count + 1;
        
        end_date := current_date;
        prc_log(log_id, process_name, tagret_table, message, user_name,
               user_win, start_date, end_date, row_count);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            prc_log(log_id, process_name, tagret_table, 'The process is executed with mistakes', user_name,
                   user_win, start_date, end_date, NULL);
    END prc_init;
    
--Execute prc_init;