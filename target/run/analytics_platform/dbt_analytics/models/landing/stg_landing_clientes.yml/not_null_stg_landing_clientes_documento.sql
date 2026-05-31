
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select documento
from "warehouse"."landing"."clientes_csv"
where documento is null



  
  
      
    ) dbt_internal_test