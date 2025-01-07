

  create or replace view `we-analysis`.`Sales_Test_prod`.`dim_orders`
  OPTIONS()
  as 
WITH orders AS (
    SELECT 
        DISTINCT order_id,
        order_state
    FROM `we-analysis`.`Sales_Test_dev`.`dev_order_payments`
)

SELECT * FROM orders;

