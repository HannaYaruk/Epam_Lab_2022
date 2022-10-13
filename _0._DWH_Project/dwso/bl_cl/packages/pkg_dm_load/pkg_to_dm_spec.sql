CREATE OR REPLACE PACKAGE pkg_dm AS

    PROCEDURE prc_dim_customers;

    PROCEDURE prc_dim_employees_scd;

    PROCEDURE prc_dim_products;

    PROCEDURE prc_dim_warehouses;

    PROCEDURE prc_dim_addresses;

    PROCEDURE prc_dim_discounts;

    PROCEDURE prc_dim_payment_types;

    PROCEDURE prc_fct_payments_dd;

    PROCEDURE prc_dim_employees_inc;

    PROCEDURE prc_fct_payments_inc;

END pkg_dm;