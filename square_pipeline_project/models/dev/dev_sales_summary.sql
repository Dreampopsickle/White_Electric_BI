{{ config(materialized='view', enabled=true) }}

WITH sales_summary AS (
    SELECT
        o.order_created_at AS order_date,
        SUM(o.total_amount) AS total_sales,
        SUM(li.gross_sales) AS total_gross_sales,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT p.payment_id) AS total_payments
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_line_items') }} li
    ON o.order_id = li.order_id
    LEFT JOIN {{ ref('stg_payments') }} p
    ON o.order_id = p.order_id
    WHERE p.payment_status = 'COMPLETED'
    GROUP BY o.order_created_at
)

SELECT * FROM sales_summary