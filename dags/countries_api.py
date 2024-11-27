import os
import sys
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.python import PythonOperator
from airflow.providers.microsoft.azure.operators.data_factory import (
    AzureDataFactoryRunPipelineOperator,
)
from cosmos import DbtTaskGroup, ExecutionConfig, ProfileConfig, ProjectConfig

from include.dag_context.main import (
    connect_to_api,
    country_info_to_datalake,
    language_to_datalake,
    load_raw_file_to_datalake,
)
from include.dag_context.transform_data_from_data_lake import (
    transform_data_from_data_lake,
)

sys.path.append(
    os.path.join(os.path.dirname(os.path.dirname(__file__)), "dag_context")
)

DBT_PROJECT_PATH = f"{os.environ['AIRFLOW_HOME']}/dags/dbt/dbt_pipeline"
profiles_yml = f"{os.environ['AIRFLOW_HOME']}/dags/dbt/dbt_pipeline/profiles.yml"

profile_config = ProfileConfig(
    profile_name="dbt_pipeline",
    target_name="dev",
    # profile_mapping=profile
    profiles_yml_filepath=profiles_yml
)


DBT_EXECUTABLE_PATH = f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt"

execution_config = ExecutionConfig(
    dbt_executable_path=DBT_EXECUTABLE_PATH
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

  start = DummyOperator(task_id='pipeline_start')
  slow_down = DummyOperator(task_id='slow_down')

  end = DummyOperator(task_id='pipeline_ends')


  api_connect = PythonOperator(
    task_id="connect_to_api",
    python_callable=connect_to_api,
    provide_context=True
  )

  load_2_data_lake = PythonOperator(
    task_id="load_2_datalake",
    python_callable=load_raw_file_to_datalake,
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

  create_countries_table = PostgresOperator(
    sql = "sql/countries.sql",
    task_id = "create_countries_table",
    postgres_conn_id = "postgres_conn"
  )
  
  create_language_table = PostgresOperator(
    sql = "sql/language.sql",
    task_id = "create_language_table",
    postgres_conn_id = "postgres_conn"
  )
  
  data_factory = AzureDataFactoryRunPipelineOperator(
        task_id="run_data_factory",
        pipeline_name="countries_api_factory",
  )

  dbt_dag = DbtTaskGroup(
      group_id="dbt_transform_data",
      project_config=ProjectConfig(DBT_PROJECT_PATH),
      profile_config=profile_config,
      execution_config=execution_config,
      operator_args={"install_deps": True},
      default_args=default_args,
  )

#   dbt_dag = DbtDag(
#     project_config=ProjectConfig(DBT_PROJECT_PATH),
#     operator_args={"install_deps": True},
#     profile_config=profile_config,
#     execution_config=execution_config,
#     default_args=default_args,
#     dag_id="dbt_dag"
# )


  ( 
    start
    >> api_connect 
    >> load_2_data_lake 
    >> transform_data
    >> [ language_2_data_lake, country_info_2_data_lake ]
    >> slow_down
    >> [ create_countries_table, create_language_table ]
    >> data_factory
    >> dbt_dag
    >> end
  )
  