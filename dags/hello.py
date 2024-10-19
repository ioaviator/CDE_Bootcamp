from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator



def hello():
  return 'Helo'

with DAG(
  dag_id='Hello',
  start_date=datetime(2024,10,18),
  schedule_interval="@hourly",
  catch_up=False
) as dag:
  task1 = PythonOperator(
    task_id='hello',
    python_callable=hello
  )

task1
