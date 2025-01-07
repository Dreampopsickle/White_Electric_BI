{{ config(materialized='view', enabled=true) }}
WITH payments AS (
    SELECT 
        DISTINCT payment_id,
        payment_status,
        payment_source
    FROM {{ ref('dev_order_payments') }}
)

SELECT * FROM payments