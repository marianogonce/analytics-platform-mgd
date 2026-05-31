
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(nombre as varchar)) = ''
