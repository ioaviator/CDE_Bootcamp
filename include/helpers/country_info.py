

def get_country_info(df):
  
  df['continent'] = df['continents'].apply(lambda x: x[0] if len(x) > 0 else None)
  df.drop('languages', axis=1, inplace=True)

  data = df[[
    'country_name', 'independent', 'unMember', 'startOfWeek',
    'official_country_name', 'common_native_name',
    'currency_codes', 'currency_names', 'currency_symbols', 
    'country_code', 'capital', 'region', 'subregion', 
    'area', 'population', 'continent'
  ]]

  
  return data