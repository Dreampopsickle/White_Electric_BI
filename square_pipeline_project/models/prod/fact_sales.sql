{{ config(materialized='view', enabled=true) }}

WITH sales_data AS (
    SELECT
        order_date,
        order_id,
        total_sales,
        total_gross_sales,we
        total_orders,
        total_payments
    from {{ ref('dev_sales_summary') }}
)

SELECT * FROM sales_data