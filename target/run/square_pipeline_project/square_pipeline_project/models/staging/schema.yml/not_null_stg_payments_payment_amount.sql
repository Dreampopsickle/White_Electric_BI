select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select payment_amount
from `we-analysis`.`Sales_Test_staging`.`stg_payments`
where payment_amount is null



      
    ) dbt_internal_test