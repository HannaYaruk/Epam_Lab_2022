--create schema
create schema if not exists user_dilab_student32;
--set search_path to dilab_student32
alter user dilab_student32 set search_path to 
'$user', 'user_dilab_student32','public';
show search_path;
--create tables for inserting
CREATE TABLE user_dilab_student32.fct_payments_dd (payment_src_id integer NOT NULL,
    product_dm_surr_id integer NOT NULL,    
    employee_dm_surr_id integer NOT NULL,
    warehouse_dm_surr_id integer NOT NULL,
    discount_dm_surr_id integer NOT NULL,
    address_dm_surr_id integer NOT NULL,
    customer_dm_surr_id integer NOT NULL,
    payment_type_dm_surr_id integer NOT NULL,
    product_cost integer NOT NULL,
    product_price integer NOT NULL,
    quantity integer NOT NULL,
    sale_date DATE NOT NULL,
    day_id DATE NOT NULL,
    update_dt DATE NOT NULL
);

CREATE TABLE user_dilab_student32.dim_customers (customer_dm_surr_id integer NOT NULL,
    customer_id      integer NOT NULL,
    source_system    VARCHAR(256) NOT NULL,
    source_entity    VARCHAR(256) NOT NULL,
    personal_id      VARCHAR(256) NOT NULL,
    first_name       VARCHAR(256) NOT NULL,
    last_name        VARCHAR(256) NOT NULL,
    email            VARCHAR(256) NOT NULL,
    address_id       integer NOT NULL,
    address          VARCHAR(256) NOT NULL,
    city_id          integer NOT NULL,
    city             VARCHAR(256) NOT NULL,
    country_id       integer NOT NULL,
    country_code     VARCHAR(256) NOT NULL,
    country_name     VARCHAR(256)NOT NULL,
    region_id        integer NOT NULL,
    region           VARCHAR(256) NOT NULL,
    postal_code      VARCHAR(256) NOT NULL,
    phone            VARCHAR(256) NOT NULL,
    update_dt        DATE NOT NULL
);


CREATE TABLE dim_products (
    product_dm_surr_id integer NOT NULL,
    product_id      integer NOT NULL,
    source_system   VARCHAR(256) NOT NULL,
    source_entity   VARCHAR(256) NOT NULL,
    product_name    VARCHAR(256) NOT NULL,
    product_desc    VARCHAR(256) NOT NULL,
    category_id     integer NOT NULL,
    category_name   VARCHAR(256) NOT NULL,
    product_cost    integer NOT NULL,
    product_price   integer NOT NULL,
    total_unit      integer NOT NULL,
    update_dt       DATE NOT NULL
);

--copy data from S3
copy user_dilab_student32.fct_payments_dd 
from 's3://hanna-yaruk/online_shop/bl_dm/fct_payments/fct_payments.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1;

copy user_dilab_student32.dim_customers 
from 's3://hanna-yaruk/online_shop/bl_dm/customers/customers.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1;

copy user_dilab_student32.dim_products 
from 's3://hanna-yaruk/online_shop/bl_dm/products/products.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1;
--count the number of rows
select count(*) as fct from fct_payments_dd;
select count(*) as cust from dim_customers;
select count(*) as prod from dim_products;
--check compression types, distribution keys, sort keys
select "column", type, encoding, distkey, sortkey
from pg_table_def where tablename = 'fct_payments_dd';

select "column", type, encoding, distkey, sortkey
from pg_table_def where schemaname = 'user_dilab_student32' and tablename = 'dim_customers';

select "column", type, encoding, distkey, sortkey
from pg_table_def where schemaname = 'user_dilab_student32' and tablename = 'dim_products';
--check distribution style
select "schema", "table", diststyle from SVV_TABLE_INFO
where "schema"='user_dilab_student32' and ("table" = 'fct_payments_dd' or "table" = 'dim_customers' or "table" = 'dim_products');

--create tables without compression
CREATE TABLE dim_products_withoutcomp (
    product_dm_surr_id integer not null encode RAW,
    product_id      integer not null encode RAW,
    source_system   VARCHAR(256) not null encode RAW,
    source_entity   VARCHAR(256) NOT null encode RAW,
    product_name    VARCHAR(256) NOT null encode RAW,
    product_desc    VARCHAR(256) NOT null encode RAW,
    category_id     integer not null encode RAW,
    category_name   VARCHAR(256) NOT null encode RAW,
    product_cost    integer not null encode RAW,
    product_price   integer not null encode RAW,
    total_unit      integer not null encode RAW,
    update_dt       DATE not null encode RAW
);

CREATE TABLE user_dilab_student32.fct_payments_dd_withoutcomp (
	payment_src_id integer NOT NULL,
    product_dm_surr_id integer NOT null encode RAW,    
    employee_dm_surr_id integer NOT null encode RAW,
    warehouse_dm_surr_id integer NOT null encode RAW,
    discount_dm_surr_id integer NOT null encode RAW,
    address_dm_surr_id integer NOT null encode RAW,
    customer_dm_surr_id integer NOT null encode RAW,
    payment_type_dm_surr_id integer NOT null encode RAW,
    product_cost integer NOT null encode RAW,
    product_price integer NOT null encode RAW,
    quantity integer NOT null encode RAW,
    sale_date DATE NOT null encode RAW,
    day_id DATE NOT null encode RAW,
    update_dt DATE NOT null encode RAW
);

--copy data from S3
copy user_dilab_student32.dim_products_withoutcomp 
from 's3://hanna-yaruk/online_shop/bl_dm/products/products.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1
compupdate off;

copy user_dilab_student32.fct_payments_dd_withoutcomp 
from 's3://hanna-yaruk/online_shop/bl_dm/fct_payments/fct_payments.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1
compupdate off;

--Check compression types, distribution keys, sort keys
select "column", type, encoding, distkey, sortkey
from pg_table_def where tablename = 'dim_products_withoutcomp';

select "column", type, encoding, distkey, sortkey
from pg_table_def where tablename = 'fct_payments_dd_withoutcomp';

--check distribution style
select "schema", "table", diststyle from SVV_TABLE_INFO
where "schema"='user_dilab_student32' and ("table" = 'dim_products_withoutcomp' or "table" = 'fct_payments_dd_withoutcomp');

--analyze compression
select count(*) as fct from fct_payments_dd_withoutcomp; 
Analyze compression fct_payments_dd_withoutcomp 
comprows 1000000;

select count(*) as prod from dim_products_withoutcomp; 
Analyze compression dim_products_withoutcomp 
comprows 70;

--create table fct_payments_dd_analyzedcomp
CREATE TABLE fct_payments_dd_analyzedcomp (
	payment_src_id integer NOT null encode AZ64,
    product_dm_surr_id integer NOT null encode AZ64,    
    employee_dm_surr_id integer NOT null encode AZ64,
    warehouse_dm_surr_id integer NOT null encode AZ64,
    discount_dm_surr_id integer NOT null encode AZ64,
    address_dm_surr_id integer NOT null encode ZSTD,
    customer_dm_surr_id integer NOT null encode AZ64,
    payment_type_dm_surr_id integer NOT null encode AZ64,
    product_cost integer NOT null encode bytedict,
    product_price integer NOT null encode bytedict,
    quantity integer NOT null encode AZ64,
    sale_date DATE NOT null encode AZ64,
    day_id DATE NOT null encode AZ64,
    update_dt DATE NOT null encode AZ64
);

--insert data 
copy user_dilab_student32.fct_payments_dd_analyzedcomp 
from 's3://hanna-yaruk/online_shop/bl_dm/fct_payments/fct_payments.csv'
credentials
'aws_iam_role=arn:aws:iam::<aws_account>:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
DATEFORMAT AS 'auto'
IGNOREHEADER 1;

select * from fct_payments_dd_analyzedcomp limit 10;

--check compression type
select "column", type, encoding
from pg_table_def where tablename = 'fct_payments_dd_analyzedcomp';

--compare the size of the tables - compressed, decompressed and dafault compressed
with table_defaultcomp as (
select 
  TRIM(name) as table_name,
  TRIM(pg_attribute.attname) AS column_name,
  COUNT(1) AS size
FROM
  svv_diskusage JOIN pg_attribute ON
    svv_diskusage.col = pg_attribute.attnum-1 AND
    svv_diskusage.tbl = pg_attribute.attrelid
where table_name = 'fct_payments_dd'
GROUP BY 1, 2),
table_withoutcomp as (
select 
  TRIM(name) as table_name,
  TRIM(pg_attribute.attname) AS column_name,
  COUNT(1) AS size
FROM
  svv_diskusage JOIN pg_attribute ON
    svv_diskusage.col = pg_attribute.attnum-1 AND
    svv_diskusage.tbl = pg_attribute.attrelid
where table_name = 'fct_payments_dd_withoutcomp'
GROUP BY 1, 2),
table_analyzedcomp as (
select 
  TRIM(name) as table_name,
  TRIM(pg_attribute.attname) AS column_name,
  COUNT(1) AS size
FROM
  svv_diskusage JOIN pg_attribute ON
    svv_diskusage.col = pg_attribute.attnum-1 AND
    svv_diskusage.tbl = pg_attribute.attrelid
where table_name = 'fct_payments_dd_analyzedcomp'
GROUP BY 1, 2)
select d.column_name,
d."size" as sizemb_default,
w."size" as sizemb_raw,
a."size" as sizemb_analyzed
from table_defaultcomp d
left join table_withoutcomp w
on d.column_name = w.column_name
left join table_analyzedcomp a
on d.column_name = a.column_name
order by d.column_name;

--Turn off the result caching
ALTER USER dilab_student32 SET enable_result_cache_for_session TO off;

--select user id
SELECT user, current_user_id; 
--user id is 118

--check the activity of the user
select * from svl_qlog
where userid = 118
ORDER BY starttime DESC;

--select statement for the procedure
explain
select personal_id, first_name, last_name, dp.product_name, dp.product_price, sale_date
from fct_payments_dd fpd  
left join dim_customers dc on dc.customer_dm_surr_id  = fpd.customer_dm_surr_id 
left join dim_products dp on dp.product_dm_surr_id = fpd.product_dm_surr_id 
where extract(year from sale_date) = '2022' and extract(month from sale_date) = '01' and dp.product_price > 3000
order by dp.product_price, dp.product_name, sale_date;

--select the results of the query in svl_qlog
select pid, starttime, substring, source_query from svl_qlog
where userid = 118
ORDER BY starttime DESC;

--check the information about optimization in the tables
select * from SVV_TABLE_INFO where schema = 'user_dilab_student32';

--change the optimization settings (for they will not change)
ALTER TABLE fct_payments_dd ALTER DISTSTYLE EVEN;
ALTER TABLE dim_customers ALTER DISTSTYLE ALL;
ALTER TABLE dim_products ALTER DISTSTYLE ALL;

ALTER TABLE fct_payments_dd ALTER SORTKEY NONE;
ALTER TABLE dim_customers ALTER SORTKEY NONE;
ALTER TABLE dim_products ALTER SORTKEY NONE;

--choose some variants of sort keys
ALTER TABLE fct_payments_dd ALTER SORTKEY (sale_date);
ALTER TABLE dim_customers ALTER SORTKEY (personal_id);
ALTER TABLE dim_products ALTER SORTKEY (product_name, product_price);

ALTER TABLE fct_payments_dd ALTER SORTKEY (sale_date);
ALTER TABLE dim_customers ALTER SORTKEY (customer_dm_surr_id);
ALTER TABLE dim_products ALTER SORTKEY (product_dm_surr_id, product_price);

ALTER TABLE fct_payments_dd ALTER SORTKEY AUTO;
ALTER TABLE dim_customers ALTER SORTKEY AUTO;
ALTER TABLE dim_products ALTER SORTKEY AUTO;

--create table for the report
CREATE TABLE IF NOT EXISTS report (personal_id VARCHAR (256),
first_name VARCHAR (256),
last_name VARCHAR (256),
product_name VARCHAR (256),
product_price integer, 
sale_date date)

--create the procedure for filling the table
CREATE OR REPLACE PROCEDURE reporting(sale_year int, sale_month int, prod_price int)
AS $$
DECLARE 
BEGIN 
--print the notice of the beginning the procedure
raise notice  'Reporting is started';
--truncate the table
truncate table report;
--print the notice of the truncating
raise notice  'Report table is truncated';
--insert data to the table
insert into report (personal_id, first_name, last_name, product_name, product_price,	sale_date)
select 
		personal_id,
		first_name,
		last_name,
		product_name,
		product_price,
		sale_date
from (
		select personal_id, first_name, last_name, dp.product_name, dp.product_price, sale_date
from fct_payments_dd fpd  
left join dim_customers dc on dc.customer_dm_surr_id  = fpd.customer_dm_surr_id 
left join dim_products dp on dp.product_dm_surr_id = fpd.product_dm_surr_id 
where extract(year from sale_date) = sale_year and extract(month from sale_date) = sale_month and dp.product_price > prod_price
order by dp.product_price, dp.product_name, sale_date);
--print the result of the procedure
raise notice 'Report data inserted';
END;
$$
LANGUAGE plpgsql
;

--call the procedure
call reporting(2022, 03, 3000);

--check the results of the procedure
select * from report;

