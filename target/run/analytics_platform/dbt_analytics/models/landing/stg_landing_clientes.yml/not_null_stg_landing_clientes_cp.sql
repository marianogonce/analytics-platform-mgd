
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cp
from "warehouse"."landing"."clientes_csv"
where cp is null



  
  
      
    ) dbt_internal_test