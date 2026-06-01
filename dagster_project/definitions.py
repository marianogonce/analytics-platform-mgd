# Definitions le dice a Dagster qué cargar. 
from dagster import Definitions 
# Importamos el job. 
from dagster_project.jobs.pipeline_clientes import pipeline_clientes 
# Registramos el job para que aparezca en la UI. 
defs = Definitions( 
jobs=[pipeline_clientes], 
) 