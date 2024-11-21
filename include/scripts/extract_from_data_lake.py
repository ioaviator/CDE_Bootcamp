
from io import BytesIO

import pandas as pd

from .auth import blob_client


def get_data_from_datalake():


  stream_downloader = blob_client.download_blob()
  stream = BytesIO()
  stream_downloader.readinto(stream)
  parquet_data = pd.read_parquet(stream, engine='pyarrow')
  
  return parquet_data
