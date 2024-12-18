{{ config(materialized='view', enabled=true) }}

WITH order_payments AS (
    SELECT 
        o.order_id,
        o.order_created_at,
        p.payment_id,
        p.payment_amount,
        p.payment_status,
        p.payment_source
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_payments' )}} p
    ON o.order_id = p.order_id
)

SELECT *
FROM order_payments