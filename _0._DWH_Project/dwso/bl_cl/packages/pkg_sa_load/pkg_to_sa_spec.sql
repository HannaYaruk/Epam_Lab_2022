CREATE OR REPLACE PACKAGE pkg_sa AS
    
    PROCEDURE prc_sa_country_regions_bel;

    PROCEDURE prc_sa_country_shortnames_bel;

    PROCEDURE prc_sa_cust_belg_src;

    PROCEDURE prc_sa_discounts_src;

    PROCEDURE prc_sa_emp_belg_src;

    PROCEDURE prc_sa_paym_type_belg_src;

    PROCEDURE prc_sa_paym_belg_src;

    PROCEDURE prc_sa_product_belg_src;

    PROCEDURE prc_sa_wareh_belg_src;

    PROCEDURE prc_sa_cust_fra_src;
    
    PROCEDURE prc_sa_emp_fra_src;

    PROCEDURE prc_sa_paym_type_fra_src;

    PROCEDURE prc_sa_paym_fra_src;

    PROCEDURE prc_sa_product_fra_src;
    
    PROCEDURE prc_sa_wareh_fra_src;
    
END pkg_sa;