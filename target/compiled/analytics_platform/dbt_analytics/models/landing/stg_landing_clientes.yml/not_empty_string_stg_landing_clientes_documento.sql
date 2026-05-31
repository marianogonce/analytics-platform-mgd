
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(documento as varchar)) = ''
