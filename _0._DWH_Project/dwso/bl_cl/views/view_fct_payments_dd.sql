CREATE OR REPLACE VIEW incr_payments AS
    ( SELECT DISTINCT
                nvl(employee_surr_id, - 1) AS e_id,
                nvl(w.warehouse_surr_id, - 1)  AS w_id,
                nvl(a.address_surr_id, - 1) AS a_id,
                nvl(payment_type_surr_id, - 1) AS pt_id,
                nvl(customer_surr_id, - 1) AS c_id,
                nvl(product_surr_id, - 1) AS p_id,
                nvl(discount_surr_id, - 1) AS d_id,
                nvl(to_number(quantity), - 1) AS q_id,
                to_date(nvl(sale_date, '31-12-9999'), 'DD-MM-YYYY') AS sd,
                nvl(to_number(payment_id), - 1) AS py_id,
                nvl(p.product_cost, - 1) AS pc,
                nvl(p.product_price, - 1) AS pp,
                to_date(sr.update_dt, 'DD-MM-YYYY')  AS dt
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
    WHERE
        sr.update_dt > (
            SELECT
                previous_loaded_dt
            FROM
                prm_mta_incremental_load
            WHERE
                table_name = 'payment_belg_src')
UNION ALL
SELECT DISTINCT
                nvl(employee_surr_id, - 1) AS e_id,
                nvl(wf.warehouse_surr_id, - 1) AS w_id,
                nvl(af.address_surr_id, - 1) AS a_id,
                nvl(payment_type_surr_id, - 1) AS pt_id,
                nvl(customer_surr_id, - 1) AS c_id,
                nvl(product_surr_id, - 1) AS p_id,
                nvl(discount_surr_id, - 1) AS d_id,
                nvl(to_number(quantity), - 1) AS q_id,
                to_date(nvl(sale_date, '31-12-9999'), 'DD-MM-YYYY') AS sd,
                nvl(to_number(payment_id), - 1) AS py_id,
                nvl(to_number(product_cost), - 1) AS py_id,
                nvl(to_number(product_price), - 1) AS pp,
                to_date(srf.update_dt, 'DD-MM-YYYY')  AS dt 
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
                                                        AND af.source_src_entity = 'WAREH_FRA_SRC'                 
                                                  AND af.source_src_system = 'SA_SRC_FRA'                  
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
                                                  AND df.source_src_system = 'SA_SRC_FRA'
                                                  AND df.source_src_entity = 'DISCOUNTS_SRC'
    WHERE
        SRF.update_dt > (
            SELECT
                previous_loaded_dt
            FROM
                prm_mta_incremental_load
            WHERE
                table_name = 'payment_fra_src'
        )
    );