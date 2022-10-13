drop TABLE paym_type_belg_src;
CREATE TABLE paym_type_belg_src (
     id_paym_type VARCHAR(256)
     , paym_type VARCHAR(256)
     , paym_acc VARCHAR(256)
     , update_dt DATE);

INSERT INTO paym_type_belg_src
SELECT id_paym_type,
     paym_type,
     paym_acc,
     current_date
FROM paym_type_belg_ext
WHERE paym_type IS NOT NULL;

COMMIT;

SELECT id_paym_type,
     paym_type,
     paym_acc,
     update_dt
FROM paym_type_belg_src;
