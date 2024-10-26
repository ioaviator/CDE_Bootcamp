from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator

from includes.load_to_db import load_to_db
from includes.download_file import download_file
from includes.process_file import process_file
from includes.create_table import create_table

BASE_URL="https://dumps.wikimedia.org/other/pageviews/2024/2024-10/"
FILE="pageviews-20241014-050000.gz"



with DAG(
  dag_id='CoreSentiment',
  start_date=datetime(2024,10,19),
  schedule_interval="@hourly",
  catchup=False
) as dag:

  download = PythonOperator(
    task_id='download_views',
    python_callable=download_file,
    op_kwargs={'url': f"{BASE_URL}{FILE}", 'location': f"/tmp/{FILE}"},
    do_xcom_push=True
  )

  extract = BashOperator(
    task_id='extract_views',
    bash_command='gzip -dv {{ task_instance.xcom_pull(task_ids="download_views") }}'
  )

  process = PythonOperator(
    task_id='process_views',
    python_callable=process_file,
    op_kwargs={'filepath': '/tmp/' + FILE.replace('.gz', '')},
    do_xcom_push=True
  )
  
  create_table = PythonOperator(
    task_id='create_table',
    python_callable=create_table,
  )

  load = PythonOperator(
    task_id='load_to_db',
    python_callable=load_to_db,
    op_kwargs={'cmds': '{{ task_instance.xcom_pull(task_ids="process_views") }}'},
  )

download >> extract >> process >> create_table >> load