from .scripts.api_connect import api_connect


def connect_to_api(**context):
  json_data = api_connect()
 
  task_instance = context['ti']
  task_instance.xcom_push(key="json_file", value=json_data)
  