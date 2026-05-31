{#
Macro para limpiar texto.
- Convierte a varchar.
- Quita espacios al inicio y al final.
- Convierte string vacío en NULL.
#}
{% macro normalize_text(column_expression) -%}
nullif(
trim(cast({{ column_expression }} as varchar)),
''
)
{%- endmacro %}
