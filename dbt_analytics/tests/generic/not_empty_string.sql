{#
Test genérico reutilizable.
dbt considera que un test falla
cuando esta consulta devuelve filas.
#}
{% test not_empty_string(model, column_name) %}
select
*
from {{ model }}
where trim(cast({{ column_name }} as varchar)) = ''
{% endtest %}