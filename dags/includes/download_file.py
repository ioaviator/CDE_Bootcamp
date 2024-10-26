import requests

def download_file(url, location):
  response = requests.get(url)
  with open(location, 'wb') as f:
    f.write(response.content)
  return location