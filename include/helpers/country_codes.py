def get_country_code(x):
  r = x.get('root', "")
  t = x.get('suffixes', "")
  if t is not None and t.size == 1:
    value = t.item()
    return str(r + value)
  else:
    return ""  

def get_country_codes(df):
  # Apply the function to the 'idd' column and create a new 'Country_Code' column
  df["country_code"] = df["idd"].apply(get_country_code)

  return df