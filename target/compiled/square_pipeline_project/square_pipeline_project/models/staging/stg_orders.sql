

SELECT
    order_id,
    created_at AS order_created_at,
    state AS order_state,
    total_money AS total_amount,
    total_tax_money AS total_tax,
    total_tip_money AS total_tip,
    total_discount_money AS total_discount
FROM 
    `we-analysis`.`Sales_Test`.`orders`