

  create or replace view `we-analysis`.`Sales_Data_prod`.`dim_orders`
  OPTIONS()
  as 
WITH orders AS (
    SELECT 
        DISTINCT order_id,
        transaction_state AS order_state
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_payments`
)

SELECT * FROM orders;

