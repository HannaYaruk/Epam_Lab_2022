CREATE OR REPLACE PROCEDURE insert_3nf AS
BEGIN
    pkg_3nf.prc_ce_payment_types;
    pkg_3nf.prc_ce_discounts;
    pkg_3nf.prc_ce_regions;
    pkg_3nf.prc_ce_countries;
    pkg_3nf.prc_ce_cities;
    pkg_3nf.prc_ce_addresses;
    pkg_3nf.prc_ce_customers;
    pkg_3nf.prc_ce_employees_inc;
    pkg_3nf.prc_ce_warehouses;
    pkg_3nf.prc_ce_categories;
    pkg_3nf.prc_ce_products;
    pkg_3nf.prc_ce_payments_inc;
END insert_3nf;

EXECUTE insert_3nf;