CREATE TABLE log_table (
    log_id       NUMBER PRIMARY KEY,
    process_name VARCHAR2(256),
    tagret_table VARCHAR2(256),
    message      VARCHAR2(256),
    user_name    VARCHAR2(256),
    user_win     VARCHAR2(256),
    start_date   TIMESTAMP,
    end_date     TIMESTAMP,
    row_count    NUMBER
);
        
--drop table LOG_TABLE