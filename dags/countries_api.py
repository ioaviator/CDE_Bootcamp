import os
import sys
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.microsoft.azure.operators.data_factory import (
    AzureDataFactoryRunPipelineOperator,
)
from airflow.providers.microsoft.azure.sensors.data_factory import (
    AzureDataFactoryPipelineRunStatusSensor,
)

from include.api_connect import connect_to_api
from include.country_info_to_data_lake import country_info_to_datalake
from include.language_info_to_data_lake import language_to_datalake
from include.load_api_to_data_lake import load_to_datalake
from include.transform_data_from_data_lake import transform_data_from_data_lake

sys.path.append(
    os.path.join(os.path.dirname(os.path.dirname(__file__)), "scripts")
)


default_args = {
    'owner': 'aviator',
    'depends_on_past': False,
    'start_date': datetime(2024, 11, 14),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'schedule_interval': '@hourly',
    "azure_data_factory_conn_id": "azure_data_factory",
    "factory_name": "cdedatafactory22",
    "resource_group_name": "cde_resource"  
}

with DAG(dag_id='countries_api', 
         catchup=False, default_args=default_args) as dag: 

  start_task = DummyOperator(task_id='pipeline_start')

  end_task = DummyOperator(task_id='pipeline_ends')

  api_connect = PythonOperator(
    task_id="connect_to_api",
    python_callable=connect_to_api,
    provide_context=True
  )

  load_2_data_lake = PythonOperator(
    task_id="load_2_datalake",
    python_callable=load_to_datalake,
    provide_context=True
  )

  
  transform_data = PythonOperator(
    task_id="transform_data",
    python_callable=transform_data_from_data_lake,
    provide_context=True
  )

  
  language_2_data_lake = PythonOperator(
    task_id="language_to_data_lake",
    python_callable=language_to_datalake,
    provide_context=True
  )
  
  country_info_2_data_lake = PythonOperator(
    task_id="country_info_to_data_lake",
    python_callable=country_info_to_datalake,
    provide_context=True
  )

  data_factory = AzureDataFactoryRunPipelineOperator(
        task_id="run_data_factory",
        pipeline_name="df_pipeline",
  )


  ( start_task 
  >> api_connect 
  >> load_2_data_lake 
  >> transform_data
  >> [language_2_data_lake, country_info_2_data_lake]
  >>  data_factory >> end_task
  )
  




# from cosmos import DbtDag, DbtTaskGroup, ExecutionConfig, ProfileConfig, ProjectConfig

# from cosmos.profiles import PostgresUserPasswordProfileMapping

# profiles_yml = f"{os.environ['AIRFLOW_HOME']}/dags/dbt/dbt_pipeline/profiles.yml"

# profile_config = ProfileConfig(
#     profile_name="default",
#     target_name="dev",
#     # profile_mapping=profile
#     profiles_yml_filepath=profiles_yml
# )


# DBT_EXECUTABLE_PATH = f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"

# execution_config = ExecutionConfig(
#     dbt_executable_path=DBT_EXECUTABLE_PATH
# )

# dbt_dag = DbtDag(
#   project_config=ProjectConfig("/usr/local/airflow/dags/dbt/dbt_pipeline"),
#   operator_args={"install_deps": True},
#   profile_config=profile_config,
#   # execution_config=execution_config,
#   dag_id="dbt_pipeline",
#   default_args=default_args
# )

