

  create or replace view `we-analysis`.`Sales_Test`.`dim_locations`
  OPTIONS()
  as WITH location_data AS (
    SELECT
        DISTINCT location_id,
        MAX(order_created_at) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders
    FROM 
        `we-analysis`.`Sales_Test`.`stg_orders`
    GROUP BY
        location_id
)

SELECT 
    * 
FROM 
    location_data;

