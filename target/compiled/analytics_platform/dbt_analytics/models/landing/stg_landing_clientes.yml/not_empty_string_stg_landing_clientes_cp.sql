
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(cp as varchar)) = ''
