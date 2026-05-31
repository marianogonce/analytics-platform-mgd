
    
    

select
    documento_normalizado as unique_field,
    count(*) as n_records

from "warehouse"."landing"."clientes_csv"
where documento_normalizado is not null
group by documento_normalizado
having count(*) > 1


