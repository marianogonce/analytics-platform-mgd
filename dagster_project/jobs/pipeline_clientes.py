# Path permite trabajar con rutas de archivos. 
from pathlib import Path 
# Importamos piezas de Dagster. 
# op define pasos. 
# job conecta pasos. 
# In, Nothing y Out permiten ordenar dependencias sin pasar datos. 
from dagster import In, Nothing, Out, job, op 
# DbtCliResource permite ejecutar comandos dbt desde Dagster. 
from dagster_dbt import DbtCliResource 
# Importamos el script Python que genera bronze. 
from scripts.landing_to_bronze_clientes import run as run_landing_to_bronze 
# Calculamos la raíz del proyecto. 
# Este archivo está en dagster_project/jobs/. 
# parents[2] apunta a analytics-platform/. 
ROOT_DIR = Path(__file__).resolve().parents[2] 
 
# Ruta al proyecto dbt. 
DBT_PROJECT_DIR = ROOT_DIR / "dbt_analytics" 
 
 
# Definimos un recurso dbt. 
# Dagster usará este recurso para ejecutar dbt run y dbt test. 
dbt_resource = DbtCliResource( 
   project_dir=str(DBT_PROJECT_DIR), 
   profiles_dir=str(DBT_PROJECT_DIR), 
) 
 
 
@op( 
   required_resource_keys={"dbt"}, 
   out=Out(Nothing), 
) 
def validar_landing_con_dbt_op(context): 
   """ 
   Paso 1: 
   Ejecuta dbt run y dbt test sobre landing. 
 
   Si el test falla, Dagster detiene el pipeline. 
   """ 
 
   context.log.info("Materializando modelo landing con dbt.") 
 
   context.resources.dbt.cli( 
       ["run", "--select", "stg_landing_clientes"], 
       context=context, 
   ).wait() 
 
   context.log.info("Ejecutando tests de calidad sobre landing.") 
 
   context.resources.dbt.cli( 
       ["test", "--select", "stg_landing_clientes"], 
       context=context, 
   ).wait() 
 
 
@op( 
   ins={"start": In(Nothing)}, 
   out=Out(Nothing), 
) 
def landing_to_bronze_op(context): 
   """ 
   Paso 2: 
   Genera Parquet en bronze usando Python. 
 
   Este paso depende de que landing haya sido validado. 
   """ 
 
   bronze_file = run_landing_to_bronze() 
   context.log.info(f"Archivo bronze generado: {bronze_file}") 
 
 
@op( 
   required_resource_keys={"dbt"}, 
   ins={"start": In(Nothing)}, 
   out=Out(Nothing), 
) 
def construir_medallon_con_dbt_op(context): 
   """ 
   Paso 3: 
   Construye bronze, silver y gold con dbt. 
   Luego ejecuta tests. 
   """ 
 
   context.log.info("Construyendo modelos dbt desde bronze hacia gold.") 
 
   context.resources.dbt.cli( 
       ["run", "--select", "src_bronze_clientes+"], 
       context=context, 
   ).wait() 
 
   context.log.info("Ejecutando tests dbt del proyecto.") 
 
   context.resources.dbt.cli( 
       ["test"], 
       context=context, 
   ).wait() 
 
 
@job( 
   resource_defs={"dbt": dbt_resource}, 
) 
def pipeline_clientes(): 
    """ 
    Job principal. 

    Orden: 
    1. Validar landing. 
    2. Generar bronze. 
    3. Construir medallón. 
    """ 
    # ¡Estas líneas deben llevar indentación!
    landing_validado = validar_landing_con_dbt_op() 
    bronze_generado = landing_to_bronze_op(landing_validado) 
    construir_medallon_con_dbt_op(bronze_generado)