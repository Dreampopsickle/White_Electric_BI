

  create or replace view `we-analysis`.`Sales_Test`.`dim_orders`
  OPTIONS()
  as 
WITH orders AS (
    SELECT 
        DISTINCT order_id,
        payment_id,
        payment_status,
        payment_source,
        payment_amount
    FROM `we-analysis`.`Sales_Test_dev`.`dev_order_payments`
)

SELECT * FROM orders;

