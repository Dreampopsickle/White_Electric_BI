<Image 
    url="../logo.png" 
    description="WE logo"
    height=200
    width=200
    border=false
    class="p-4"
/>

# May Sales Report

```may_sales
select
    distinct dp.transaction_id as payment_id,
    fs.payment_total as payment_total,
    fs.transaction_tax_amount as tax_amount
from
    we_sales_data.fact_sales fs
join
    we_sales_data.dim_payments dp
on
    fs.transaction_id = dp.transaction_id
join
    we_sales_data.dim_time dt
on
    fs.date_time_key = dt.date_time_key
where
    dt.year = 2023 AND dt.month = 5
```

```sum_total
select
    sum(payment_total) as total_amt,
    sum(tax_amount) as tax,
    sum(payment_total) - sum(tax_amount) as total
from ${may_sales}
```

<BigValue
    data={sum_total}
    value=total
    fmt=usd2
/>
