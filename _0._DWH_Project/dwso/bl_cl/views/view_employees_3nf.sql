CREATE OR REPLACE VIEW incr_employees AS
    ( SELECT DISTINCT
        nvl(id_emp, 'N/A')                                 AS src_id,
        'SA_SRC_BELG'                                      AS src_system,
        'EMP_BELG_SRC'                                    AS src_entity,
        nvl(personal_id, 'N/A')                            AS personal_id,
        nvl(first_name, 'N/A')                             AS first_name,
        nvl(last_name, 'N/A')                              AS last_name,
        nvl(email, 'N/A')                                  AS email,
        nvl(address_surr_id, - 1)                          AS surr_id,
        nvl(emp_type, 'N/A')                               AS emp_type,
        to_date(nvl(start_dt, current_date), 'DD-MM-YYYY') AS start_dt,
        to_date(nvl(end_dt, '31-12-9999'), 'DD-MM-YYYY')   AS end_dt,
        nvl(curr_flag, 'Y')                                AS curr_flag,
        current_date                                       AS dt
    FROM 
        sa_source_bel.emp_belg_src b
        LEFT JOIN bl_3nf.ce_addresses        a ON b.address = a.address
    WHERE
        b.update_dt > (
            SELECT
                previous_loaded_dt
            FROM
                prm_mta_incremental_load
            WHERE
                table_name = 'emp_belg_src'
        )
    UNION ALL
    SELECT DISTINCT
        nvl(id_emp, 'N/A')                                 AS src_id,
        'SA_SRC_FRA'                                       AS src_system,
        'EMP_FRA_SRC'                                     AS src_entity,
        nvl(personal_id, 'N/A')                            AS personal_id,
        nvl(first_name, 'N/A')                             AS first_name,
        nvl(last_name, 'N/A')                              AS last_name,
        nvl(email, 'N/A')                                  AS email,
        nvl(address_surr_id, - 1)                          AS surr_id,
        nvl(emp_type, 'N/A')                               AS emp_type,
        to_date(nvl(start_dt, current_date), 'DD-MM-YYYY') AS start_dt,
        to_date(nvl(end_dt, '31-12-9999'), 'DD-MM-YYYY')   AS end_dt,
        nvl(curr_flag, 'Y')                                AS curr_flag,
        current_date                                       AS dt
    FROM
        sa_source_fra.emp_fra_src f
        LEFT JOIN bl_3nf.ce_addresses       a ON f.address = a.address
    WHERE
        f.update_dt > (
            SELECT
                previous_loaded_dt
            FROM
                prm_mta_incremental_load
            WHERE
                table_name = 'emp_fra_src'
        )
    );
    