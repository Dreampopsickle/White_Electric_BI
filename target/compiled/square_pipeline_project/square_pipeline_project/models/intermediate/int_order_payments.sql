WITH joined_data AS (
    SELECT
        o.order_id,
        o.location_id,
        o.order_created_at,
        o.order_updated_at,
        o.order_state,
        o.total_amount AS order_total_amount,
        o.total_tax,
        o.total_tip,
        p.payment_id,
        p.payment_created_at,
        p.payment_updated_at,
        p.amount AS payment_amount,
        p.currency AS payment_currency, 
        p.status AS payment_status,
        p.source_type
    FROM 
        `we-analysis`.`Sales_Test`.`stg_orders` o
    LEFT JOIN
        `we-analysis`.`Sales_Test`.`stg_payments` p
    ON o.order_id = p.order_id
)

SELECT
    *
FROM 
    joined_data