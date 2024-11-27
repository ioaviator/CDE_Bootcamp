import pandas as pd


def get_country_language(df):
  languages = pd.json_normalize(df[['country_name', 'languages']].to_dict(orient="records"), 
                                 record_prefix="languages_", 
                                 meta=["country_name"])

  # Melt the DataFrame to create separate rows for each language, and remove language_code
  languages_df = languages.melt(id_vars="country_name", 
                                        value_name="language_name").dropna().reset_index(drop=True)

  # Drop the 'variable' column (formerly the 'language_code' column)
  languages_df = languages_df[["country_name", "language_name"]]

  return languages_df