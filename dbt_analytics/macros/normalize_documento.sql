{#
Macro para normalizar CUIT o DNI.
Ejemplo:
"20-12345678-3" pasa a "20123456783".
#}
{% macro normalize_documento(column_expression) -%}
{#
regexp_replace busca un patrón y lo reemplaza.
'[^0-9]' significa:
cualquier carácter que NO sea número.
'' significa:
reemplazarlo por nada.
'g' significa:
hacerlo de forma global.
#}
regexp_replace(
cast({{ column_expression }} as varchar),
'[^0-9]',
'',
'g'
)
{%- endmacro %}
