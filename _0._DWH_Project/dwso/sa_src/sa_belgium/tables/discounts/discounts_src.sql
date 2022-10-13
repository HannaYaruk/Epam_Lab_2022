drop TABLE discounts_src;
CREATE TABLE discounts_src (
    id_disc VARCHAR(256)
    , title VARCHAR(256)
    , percentage VARCHAR(256)
    , update_dt DATE);

INSERT INTO discounts_src
SELECT id_disc,
     title,
     percentage,
     current_date
FROM discounts_ext;

COMMIT;

SELECT id_disc,
     title,
     percentage,
     update_dt
FROM discounts_src;
