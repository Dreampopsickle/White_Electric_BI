# February Sales Report

## Daily Sales Revenue and Total Items Sold

```sales
SELECT
    fs.payment_id as payment_id,
    fs.order_id as order_id,
    fs.line_item_id as item_id,
    fs.date_time_key,
    dt.timestamp_utc,
    dt.timestamp_est,
    di.item_name as item_name,
    fs.item_quantity as item_quantity,
    fs.item_base_price as item_base_price,
    fs.item_gross_sales as item_gross_sale,
    fs.order_tax as order_tax,
    fs.order_tip as order_tip,
    fs.modifier_price as modifier_price,
    di.modifier_name as modifier_name,
    fs.payment_total as order_total
FROM we_sales_data.fact_sales fs
JOIN we_sales_data.dim_time dt
ON fs.date_time_key = dt.date_time_key
JOIN we_sales_data.dim_payments dp
ON fs.payment_id = dp.payment_id
JOIN we_sales_data.dim_items di
ON fs.line_item_id = di.item_id
ORDER BY dt.timestamp_utc
```

```categories
SELECT DISTINCT
    item_name,
    CASE
        WHEN item_name IN ('Gift Card', 'Spindrift', 'Coke', 'Candy Bar', 'WE Sticker', 'Coffee Beans', 'Lemonade', 'Bottled Water', '1/2 Gal Iced Coffee') THEN 'Misc.'
        WHEN item_name IN ('Knead Donut', 'Cookie', 'Cinnamon Bun', 'Ham&Chz', 'Almond Croissant', 'Muffin', 'Cranberry Pecan Bread', 'Popover', 'PecanBun') THEN 'Pastries'
        WHEN item_name IN ('Bagel + Butter/EB', 'Bagels', 'Egg + Cheese', 'Turkey Sandwich', 'Special Turkey Sandwich', 'Bagel + Cream Cheese', 'Chicken Salad Sandwich', 'CC + Avo', 'Ham Sandwich', 'Hummus Sandwich', 'Bagel + Chive CC', 'CC + Lox + Red Onion', 'Hummus + Tomato', 'Avocado BLT Sandwich', 'Special Pesto Sandwich', 'Avo Toast', 'Veggie Sandwich', 'Lox Special', 'Avocado Garden Sandwich', 'Pesto Sandwich', 'Egg and Cheese Sandwich', 'Avo Garden Salad', 'Sriracharella Sandwich', 'White Electric Salad') THEN 'Food'
        ELSE 'Beverages'
    END AS category,
    SUM(order_total) as total
FROM ${sales}
WHERE item_name != ''
GROUP BY item_name
ORDER BY category
```

<BarChart
    data={categories}
    x=category
    y=total
    swapXY=true
    yFmt=usd
/>
