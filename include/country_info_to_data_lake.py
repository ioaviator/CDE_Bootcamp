from .scripts.cleaned_data_to_data_lake import load_to_data_lake


def country_info_to_datalake(**context):

  ti = context['ti']

  json = ti.xcom_pull(task_ids='transform_data',key='country_json')
  
  data = load_to_data_lake(json, 'clean', 'country_info.csv')
