drop TABLE cust_belg_src;
CREATE TABLE cust_belg_src (
    id_cust VARCHAR(256) 
    , personal_id VARCHAR(256)
    , first_name VARCHAR(256)
    , last_name VARCHAR(256)
    , address VARCHAR(256)
    , city VARCHAR(256)
    , country_code VARCHAR(256)
    , country_name VARCHAR(256)
    , postal_code VARCHAR(256)
    , phone VARCHAR(256)
    , update_dt date);


INSERT INTO cust_belg_src
SELECT id_cust,
     personal_id,
     first_name,
     last_name,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     current_date
FROM cust_belg_ext;

COMMIT;

SELECT id_cust,
     personal_id,
     first_name,
     last_name,
     address,
     city,
     country_code,
     country_name,
     postal_code,
     phone,
     update_dt
    FROM cust_belg_src;
