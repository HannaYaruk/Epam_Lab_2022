--Create meta-table for incremental loading
--DROP TABLE prm_mta_incremental_load;
CREATE TABLE prm_mta_incremental_load (
    table_name        VARCHAR(256),
    target_table_name    VARCHAR(256),
    package_ttl          VARCHAR(256),
    procedure_ttl        VARCHAR(256),
    previous_loaded_dt DATE DEFAULT current_date
); 
