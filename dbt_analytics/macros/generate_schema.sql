{#
Macro especial de dbt para controlar nombres de schemas.
Si un modelo define schema = "silver",
queremos que el objeto se cree en silver,
no en main_silver.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
{#
custom_schema_name es el schema indicado en el modelo.
Ejemplo:
config(schema = "silver")
hace que custom_schema_name valga "silver".
#}
{%- if custom_schema_name is none -%}
{#
Si el modelo no define schema,
usamos el schema por defecto del perfil:
target.schema.
#}
{{ target.schema }}
{%- else -%}
{#
Si el modelo define schema,
usamos ese valor.
trim limpia espacios al inicio o al final.
#}
{{ custom_schema_name | trim }}
{%- endif -%}
{%- endmacro %}