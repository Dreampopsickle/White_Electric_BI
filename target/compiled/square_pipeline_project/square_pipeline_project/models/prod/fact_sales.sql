

WITH fact_sales AS (
    SELECT
        op.payment_id,
        op.order_id,
        oi.line_item_id,
        oi.item_quantity,
        oi.item_base_price,
        oi.item_gross_sales,
        op.order_tax,
        op.order_tip,
        oi.modifier_price,
        op.payment_net_amount AS payment_total
    FROM `we-analysis`.`Sales_Test_dev`.`dev_order_payments` op
    JOIN `we-analysis`.`Sales_Test_dev`.`dev_order_items` oi
    ON op.order_id = oi.order_id
)

SELECT * FROM fact_sales