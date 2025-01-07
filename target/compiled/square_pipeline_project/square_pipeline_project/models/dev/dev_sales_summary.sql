

WITH sales_summary AS (
    SELECT
        o.order_id,
        o.order_created_at AS order_date,
        SUM(p.payment_net_amount) AS total_sales,
        SUM(li.item_gross_sales) AS total_gross_sales,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT p.payment_id) AS total_payments,
        COUNT(DISTINCT li.line_item_id) AS total_line_items
    FROM `we-analysis`.`Sales_Test_staging`.`stg_orders` o
    LEFT JOIN `we-analysis`.`Sales_Test_staging`.`stg_line_items` li
    ON o.order_id = li.order_id
    LEFT JOIN `we-analysis`.`Sales_Test_staging`.`stg_payments` p
    ON o.order_id = p.order_id
    WHERE p.payment_status = 'COMPLETED' AND o.order_state = 'COMPLETED'
    GROUP BY o.order_created_at, o.order_id
)

SELECT * FROM sales_summary