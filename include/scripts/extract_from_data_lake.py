
import pandas as pd

from .auth import blob_url


def get_data_from_datalake():


  data = pd.read_parquet(blob_url)
  
  return data
