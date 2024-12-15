WITH item_data as (
    SELECT 
        DISTINCT 
        item_name,
        modifier_name,
        base_price,
        gross_sales
    FROM 
        {{ ref('stg_line_items') }}
)

SELECT 
    *
FROM 
    item_data