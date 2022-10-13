--create external schema
CREATE EXTERNAL SCHEMA if not exists user_dilab_student32_ext
FROM DATA catalog
DATABASE 'hanna_yaruk'
IAM_ROLE 'arn:aws:iam::<aws_account>:role/dilab-redshift-role';

select * from pg_catalog.svv_external_schemas 
where schemaname ='user_dilab_student32_ext';

--export data to S3
UNLOAD ('select *, CAST(TO_CHAR(day_id, ''YYYY-MM'') AS varchar) as part from fct_payments_dd')
TO 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/' 
IAM_ROLE 'arn:aws:iam::<aws_account>:role/dilab-redshift-role'
CSV DELIMITER AS ','
PARTITION BY (part);

--drop TABLE  user_dilab_student32_ext.ext_student32_partitioned;
--create partitioned external table
CREATE external TABLE  user_dilab_student32_ext.ext_student32_partitioned
   (payment_src_id integer,
    product_dm_surr_id integer,    
    employee_dm_surr_id integer,
    warehouse_dm_surr_id integer,
    discount_dm_surr_id integer,
    address_dm_surr_id integer,
    customer_dm_surr_id integer,
    payment_type_dm_surr_id integer,
    product_cost integer,
    product_price integer,
    quantity integer,
    sale_date DATE,
    day_id DATE,
    update_dt DATE
   )
partitioned by (part varchar)
row format delimited
fields terminated by ','
stored as textfile
location 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

select count(*) from user_dilab_student32_ext.ext_student32_partitioned;

--add partitions to the table
ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-01') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-02') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-03') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-04') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-05') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-06') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-07') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-08') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-09') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-10') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-11') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2020-12') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-01') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-02') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-03') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-04') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-05') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-06') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-07') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-08') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-09') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-10') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-11') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2021-12') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2022-01') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2022-02') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

ALTER TABLE user_dilab_student32_ext.ext_student32_partitioned
ADD IF NOT EXISTS PARTITION (part='2022-03') 
LOCATION 's3://hanna-yaruk/online_shop/bl_dm/fct_payments_dd_unload/';

--verify data in partitioned external table
SELECT count(r.*) AS redshift_table, count(e.*) AS external_table,
	CASE WHEN ((redshift_table - external_table) = 0) 
		THEN 'OK'
		ELSE 'Not OK'
		END
FROM user_dilab_student32.fct_payments_dd AS r
INNER JOIN user_dilab_student32_ext.ext_student32_partitioned AS e
ON r.payment_src_id = e.payment_src_id
AND r.product_dm_surr_id = e.product_dm_surr_id
AND r.employee_dm_surr_id = e.employee_dm_surr_id
AND r.warehouse_dm_surr_id = e.warehouse_dm_surr_id
AND r.discount_dm_surr_id = e.discount_dm_surr_id
AND r.address_dm_surr_id = e.address_dm_surr_id
AND r.customer_dm_surr_id = e.customer_dm_surr_id
AND r.payment_type_dm_surr_id = e.payment_type_dm_surr_id
AND r.product_cost = e.product_cost
AND r.product_price = e.product_price
AND r.quantity = e.quantity
AND r.sale_date = e.sale_date
WHERE TO_CHAR(r.day_id, 'YYYY-MM') = '2021-09';

--explain plan
EXPLAIN
SELECT * FROM user_dilab_student32_ext.ext_student32_partitioned 
WHERE part = '2021-09' ;
