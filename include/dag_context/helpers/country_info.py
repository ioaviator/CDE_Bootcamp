

def get_country_info(df):
  
  df['continent'] = df['continents'].apply(lambda x: x[0] if len(x) > 0 else None)
  df['capital'] = df['capital'].apply(lambda x: x[0] if isinstance(x, list) and x else None)
  df.columns = df.columns.map(lambda x: x.lower().strip())
  
  df.drop('languages', axis=1, inplace=True)

  data = df[[
    'country_name', 'independent', 'unmember', 'startofweek',
    'official_country_name', 'common_native_name',
    'currency_codes', 'currency_names', 'currency_symbols', 
    'country_code', 'capital', 'region', 'subregion', 
    'area', 'population', 'continent'
  ]]

  
  return data