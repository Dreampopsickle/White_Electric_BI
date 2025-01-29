# February Sales Report

## Daily Sales Revenue and Total Items Sold

```may_sales
select
    dt.year as year,
    dt.month as month,
    dt.day_name as day,
    dt.hour as hour,
    dt.minute as minute,
    dp.transaction_state as payment_state,
    dp.transaction_source as payment_source,
    dp.transaction_method as payment_method,
    dio.order_state as order_state,
    dio.order_id as order_id,
    di.item_name as item_name,
    di.modifier_name as modifier_name,
    fs.item_quantity as item_quantity,
    fs.item_base_price as item_base_price,
    fs.item_gross_amt as item_gross_amt,
    fs.modifier_price as modifier_price,
    fs.payment_total as payment_total
from we_sales_data.fact_sales fs
join we_sales_data.dim_time dt
on fs.date_time_key = dt.date_time_key
join we_sales_data.dim_payments dp
on fs.transaction_id = dp.transaction_id
join we_sales_data.dim_orders dio
on fs.order_id = dio.order_id
join we_sales_data.dim_items di
on fs.line_item_id = di.item_id
where dt.month = 5
order by dt.timestamp_utc
```

```item_count
select
    COUNT(distinct order_id) as count,
    month,
from ${may_sales}
group by month

```

<BarChart
    data={item_count}
    x=month
    y=count
    xFmt=mmm
/>
