

  create or replace view `we-analysis`.`Sales_Data_prod`.`dim_orders`
  OPTIONS()
  as 
WITH dim_orders AS (
    SELECT 
        DISTINCT order_id,
        order_state
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_payments`
)

SELECT * FROM dim_orders;

