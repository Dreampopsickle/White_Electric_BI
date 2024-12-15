WITH location_data AS (
    SELECT
        DISTINCT location_id,
        MAX(order_created_at) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders
    FROM 
        {{ ref('stg_orders') }}
    GROUP BY
        location_id
)

SELECT 
    * 
FROM 
    location_data