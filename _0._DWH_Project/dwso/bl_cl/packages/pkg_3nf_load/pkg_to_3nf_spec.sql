CREATE OR REPLACE PACKAGE pkg_3nf AS
--Procedures for load
    PROCEDURE prc_ce_payment_types;

    PROCEDURE prc_ce_discounts;

    PROCEDURE prc_ce_regions;

    PROCEDURE prc_ce_countries;

    PROCEDURE prc_ce_cities;

    PROCEDURE prc_ce_addresses;

    PROCEDURE prc_ce_customers;

    PROCEDURE prc_ce_employees;

    PROCEDURE prc_ce_warehouses;

    PROCEDURE prc_ce_categories;

    PROCEDURE prc_ce_products;

    PROCEDURE prc_ce_payments_dd;
--Procedures for incremental load   
    PROCEDURE prc_ce_employees_inc;

    PROCEDURE prc_ce_payments_inc;

END pkg_3nf;