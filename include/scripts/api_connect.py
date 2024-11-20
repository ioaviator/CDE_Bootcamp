import requests


def api_connect() -> list:
  raw_data = requests.get('https://restcountries.com/v3.1/all')
  data = raw_data.json()

  return data