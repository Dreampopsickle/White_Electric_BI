

  create or replace view `we-analysis`.`Sales_Test_prod`.`fact_sales`
  OPTIONS()
  as 

WITH sales_data AS (
    SELECT
        order_date,
        order_id,
        total_sales,
        total_gross_sales,we
        total_orders,
        total_payments
    from `we-analysis`.`Sales_Test_dev`.`dev_sales_summary`
)

SELECT * FROM sales_data;

