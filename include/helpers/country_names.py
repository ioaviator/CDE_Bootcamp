
def get_common_native_name(row):
    # Ensure native_names is not None and is a dictionary
    native_names = row.get('name', {}).get('nativeName', {})
    if not native_names or not isinstance(native_names, dict):
        return 'Unknown'
    
    # Extract the 'common' key from each language in nativeName if present
    common_names = [value.get('common', 'Unknown') for value in native_names.values() if value and isinstance(value, dict)]
    return ", ".join(common_names) if common_names else 'Unknown'




def get_country_names(df):
  df['country_name'] = df['name'].apply(lambda x: x.get('common'))
  df['official_country_name'] = df['name'].apply(lambda x: x.get('official'))
  
  # Apply the function to extract the common native name
  df['common_native_name'] = df.apply(lambda row: get_common_native_name(row), axis=1)

  return df