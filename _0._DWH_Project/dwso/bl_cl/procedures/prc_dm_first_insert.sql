CREATE OR REPLACE PROCEDURE dm_insert_first AS
BEGIN
    pkg_dm.prc_dim_customers;
    pkg_dm.prc_dim_employees_scd;
    pkg_dm.prc_dim_products;
    pkg_dm.prc_dim_warehouses;
    pkg_dm.prc_dim_addresses;
    pkg_dm.prc_dim_discounts;
    pkg_dm.prc_dim_payment_types;
    pkg_dm.prc_fct_payments_dd;
END dm_insert_first;

--EXECUTE dm_insert_first;