
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select documento_normalizado
from "warehouse"."landing"."clientes_csv"
where documento_normalizado is null



  
  
      
    ) dbt_internal_test