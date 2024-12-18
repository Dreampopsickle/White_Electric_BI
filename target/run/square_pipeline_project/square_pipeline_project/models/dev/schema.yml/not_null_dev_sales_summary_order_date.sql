select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select order_date
from `we-analysis`.`Sales_Test_dev`.`dev_sales_summary`
where order_date is null



      
    ) dbt_internal_test