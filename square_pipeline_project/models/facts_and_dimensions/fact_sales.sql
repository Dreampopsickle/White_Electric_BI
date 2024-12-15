WITH sales_data AS (
    SELECT
        o.order_id,
        o.location_id,
        o.order_created_at,
        o.order_state,
        o.total_amount AS revenue,
        o.total_tax AS tax_amount,
        o.total_tip AS tip_amount,
        SUM(COALESCE(li.quantity, 0)) AS total_items_sold,
        --Derived metrics
        SAFE_DIVIDE(o.total_amount, SUM(COALESCE(li.quantity, 0))) AS average_order_value,
        SAFE_DIVIDE(o.total_tax, o.total_amount) * 100 AS tax_percentage,
        SAFE_DIVIDE(o.total_tip, o.total_amount) * 100 AS tip_percentage
    FROM 
        {{ ref('int_order_items') }} li
    JOIN 
        {{ ref('stg_orders') }} o
    ON 
        li.order_id = o.order_id
    WHERE
        o.order_state = 'COMPLETED'
    GROUP BY
        o.order_id,
        o.location_id,
        o.order_created_at,
        o.order_state,
        o.total_amount, 
        o.total_tax,
        o.total_tip
)

SELECT
    *
FROM 
    sales_data