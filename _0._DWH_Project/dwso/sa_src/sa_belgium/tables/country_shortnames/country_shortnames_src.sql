drop TABLE country_shortnames_src;
CREATE TABLE country_shortnames_src (
    country_id      VARCHAR(10),
     country_desc    VARCHAR(256),
     country_code    VARCHAR(256),
     update_dt DATE);


INSERT INTO country_shortnames_src
SELECT country_id,
          country_desc,
          country_code,
          current_date
FROM country_shortnames_ext;

COMMIT;

SELECT country_id,
          country_desc,
          country_code,
          update_dt
    FROM country_shortnames_src;
