{{ config(materialized='view', enabled=true) }}
WITH orders AS (
    SELECT 
        DISTINCT order_id,
        payment_id,
        payment_status,
        payment_source,
        payment_amount
    FROM {{ ref('dev_order_payments') }}
)

SELECT * FROM orders

