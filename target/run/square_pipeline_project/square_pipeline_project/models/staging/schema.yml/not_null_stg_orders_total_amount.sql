select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select total_amount
from `we-analysis`.`Sales_Test_staging`.`stg_orders`
where total_amount is null



      
    ) dbt_internal_test