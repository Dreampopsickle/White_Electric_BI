

WITH sales_data AS (
    SELECT
        order_date,
        order_id,
        total_sales,
        total_gross_sales,
        total_orders,
        total_payments
    from `we-analysis`.`Sales_Test_dev`.`dev_sales_summary`
)

SELECT * FROM sales_data