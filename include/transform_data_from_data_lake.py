from .helpers.country_codes import get_country_codes
from .helpers.country_curriencies import get_country_currencies
from .helpers.country_info import get_country_info
from .helpers.country_language import get_country_language
from .helpers.country_names import get_country_names
from .scripts.extract_from_data_lake import get_data_from_datalake


def transform_data_from_data_lake(**context):
  df_data = get_data_from_datalake()
  
  df = get_country_names(df_data)

  df = get_country_currencies(df)
  df = get_country_codes(df)

  df_language = get_country_language(df)

  df_country_info = get_country_info(df)

  task_instance = context['ti']
  task_instance.xcom_push(key="language_json", value=df_language)
  task_instance.xcom_push(key="country_json", value=df_country_info)
  