{{ config(materialized='view', enabled=true) }}
WITH dim_payments AS (
    SELECT 
        DISTINCT payment_id,
        payment_status,
        payment_source,
        application_detail AS payment_method
    FROM {{ ref('dev_order_payments') }}
)

SELECT * FROM dim_payments