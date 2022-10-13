CREATE OR REPLACE PROCEDURE insert_3nf_first AS
BEGIN
    pkg_3nf.prc_ce_payment_types;
    pkg_3nf.prc_ce_discounts;
    pkg_3nf.prc_ce_regions;
    pkg_3nf.prc_ce_countries;
    pkg_3nf.prc_ce_cities;
    pkg_3nf.prc_ce_addresses;
    pkg_3nf.prc_ce_customers;
    pkg_3nf.prc_ce_employees;
    pkg_3nf.prc_ce_warehouses;
    pkg_3nf.prc_ce_categories;
    pkg_3nf.prc_ce_products;
    pkg_3nf.prc_ce_payments_dd;
END insert_3nf_first;

--EXECUTE insert_3nf_first;