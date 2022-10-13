drop TABLE country_regions_src;
CREATE TABLE country_regions_src (
    country_id      VARCHAR(256),
     country_desc    VARCHAR(256),
     structure_code    VARCHAR(256),
     structure_desc VARCHAR(256),
     update_dt date);


INSERT INTO country_regions_src
SELECT country_id
       ,country_desc
       ,structure_code
       ,structure_desc
       ,current_date
FROM country_regions_ext;

COMMIT;

SELECT country_id
       ,country_desc
       ,structure_code
       ,structure_desc
       ,update_dt
    FROM country_regions_src;
