CREATE OR REPLACE PROCEDURE prc_init_dim IS

        log_id       NUMBER := log_id_seq.nextval;
        process_name VARCHAR2(256) := ( 'DM_Loading' );
        tagret_table VARCHAR2(256) := ( 'BL_DM.ALL_tables' );
        message      VARCHAR2(256) := ( 'INIT_tables insert' );
        user_name    VARCHAR2(256) := ( 'BL_CL' );
        user_win     VARCHAR2(256) := sys_context('USERENV', 'SESSION_USER');
        start_date   TIMESTAMP := current_date;
        end_date     TIMESTAMP := NULL;
        row_count    NUMBER := 0;
    BEGIN
        INSERT INTO bl_dm.dim_employees_scd (
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
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY'),
            TO_DATE('12-31-9999', 'MM-DD-YYYY'),
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_customers (
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
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_products (
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
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            - 1,
            - 1,
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_warehouses (
            warehouse_dm_surr_id,
            warehouse_id,
            warehouse_name,
            source_system,
            source_entity,
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
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            - 1,
            - 1,
            'N/A',
            'N/A',
            - 1,
            - 1,
            - 1,
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_addresses (
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
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            'N/A',
            - 1,
            'N/A',
            - 1,
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_discounts (
            discount_dm_surr_id,
            discount_id,
            source_system,
            source_entity,
            discount_title,
            discount_percentage,
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            - 1,
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.dim_payment_types (
            payment_type_dm_surr_id,
            payment_type_id,
            source_system,
            source_entity,
            payment_type,
            payment_account,
            update_dt
        ) VALUES (
            - 1,
            - 1,
            'N/A',
            'N/A',
            'N/A',
            'N/A',
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
        );

        COMMIT;
        row_count := row_count + 1;
        INSERT INTO bl_dm.fct_payments_dd (
            payment_src_id,
            employee_dm_surr_id,
            warehouse_dm_surr_id,
            discount_dm_surr_id,
            address_dm_surr_id,
            customer_dm_surr_id,
            payment_type_dm_surr_id,
            product_dm_surr_id,
            product_cost,
            product_price,
            quantity,
            sale_date,
            day_id,
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
            - 1,
            - 1,
            - 1,
            TO_DATE('12-31-9999', 'MM-DD-YYYY'),
            TO_DATE('12-31-9999', 'MM-DD-YYYY'),
            TO_DATE('12-31-9999', 'MM-DD-YYYY')
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
    END prc_init_dim;

--Execute prc_init_dim;