

def get_country_currencies(df):

  df["currency_codes"] = df["currencies"].apply(
  lambda x: ", ".join([code for code, details in x.items() if details]) if x else "")

  df["currency_names"] = df["currencies"].apply(
      lambda x: ", ".join(details.get("name", "Unknown") for details in x.values() if details) if x else "Unknown"
  )

  df["currency_symbols"] = df["currencies"].apply(
      lambda x: ", ".join(details.get("symbol", "Unknown") for details in x.values() if details) if x else "Unknown"
  )

  return df