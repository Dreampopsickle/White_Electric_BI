select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select total_sales
from `we-analysis`.`Sales_Test`.`fact_sales`
where total_sales is null



      
    ) dbt_internal_test