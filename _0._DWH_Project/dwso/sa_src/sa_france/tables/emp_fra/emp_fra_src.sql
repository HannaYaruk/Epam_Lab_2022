drop TABLE emp_fra_src;
CREATE TABLE emp_fra_src (
     id_emp      VARCHAR(256),
     personal_id VARCHAR(256),
     first_name    VARCHAR(256),
     last_name    VARCHAR(256),
     email VARCHAR(256),
     address      VARCHAR(256),
     city    VARCHAR(256),
     country_code    VARCHAR(256),
     country_name VARCHAR(256),
     postal_code      VARCHAR(256),
     phone    VARCHAR(256),
     emp_type VARCHAR(256),
     start_dt VARCHAR(256),
     end_dt VARCHAR(256),
     curr_flag VARCHAR(256),
     update_dt DATE);

INSERT INTO emp_fra_src
SELECT id_emp,
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
FROM emp_fra_ext;

COMMIT;

SELECT id_emp,
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
     update_dt
FROM emp_fra_src;
