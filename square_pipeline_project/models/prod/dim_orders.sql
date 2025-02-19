{{ config(materialized='view', enabled=true) }}
WITH dim_orders AS (
    SELECT 
        DISTINCT order_id,
        order_state
    FROM {{ ref('dev_order_payments') }}
)

SELECT * FROM dim_orders

