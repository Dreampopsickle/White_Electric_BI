{{ config(materialized='view', enabled=true) }}
WITH payments AS (
    SELECT 
        DISTINCT transaction_id,
        transaction_state,
        transaction_source,
        transaction_method
    FROM {{ ref('dev_order_payments') }}
)

SELECT * FROM payments