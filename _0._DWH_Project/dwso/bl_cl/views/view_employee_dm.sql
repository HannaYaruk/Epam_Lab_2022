CREATE OR REPLACE VIEW incr_employees AS 
(  SELECT DISTINCT
                      employee_surr_id as e_surr,
                      'BL_3NF'           AS src_system,
                      'CE_EMPLOYEES_SCD' AS src_entity,
                      personal_id AS p_id,
                      first_name as f_name,
                      last_name as l_name,
                      email as mail,
                      a.address_surr_id as a_surr,
                      address as addr,
                      c.city_surr_id as c_surr,
                      city as cty,
                      ctr.country_surr_id as ctr_surr,
                      country_code as c_code,
                      country_name as c_name,
                      r.region_surr_id as r_surr,
                      region as reg,
                      postal_code as p_code,
                      phone as p_hone,
                      employee_type as e_type,
                      start_dt as s_dt,
                      end_dt as e_dt,
                      current_flag as c_flag
                  FROM
                      bl_3nf.ce_employees_scd emp 
                      LEFT JOIN bl_3nf.ce_addresses     a ON emp.address_surr_id = a.address_surr_id
                      LEFT JOIN bl_3nf.ce_cities        c ON a.city_surr_id = c.city_surr_id
                      LEFT JOIN bl_3nf.ce_countries     ctr ON c.country_surr_id = ctr.country_surr_id
                      LEFT JOIN bl_3nf.ce_regions       r ON ctr.region_surr_id = r.region_surr_id
    WHERE
        emp.update_dt > (
            SELECT
                previous_loaded_dt
            FROM
                prm_mta_incremental_load
            WHERE
                table_name = 'ce_employees_scd'
        )
    );