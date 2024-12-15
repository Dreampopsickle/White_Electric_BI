

  create or replace view `we-analysis`.`Sales_Test`.`stg_orders`
  OPTIONS()
  as WITH orders as (
    SELECT 
        order_id,
        location_id, 
        created_at AS order_created_at, 
        updated_at AS order_updated_at,
        state AS order_state,
        CAST(total_money AS FLOAT64) AS total_amount,
        CAST(total_tax_money AS FLOAT64) AS total_tax,
        CAST(total_tip_money AS FLOAT64) AS total_tip,
        CAST(total_discount_money AS FLOAT64) AS total_discount
    FROM `we-analysis`.`Sales_Test`.`orders`
)

SELECT 
    *
FROM 
    orders;

