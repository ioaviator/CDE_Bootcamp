
resource "azurerm_data_factory_dataset_delimited_text" "cdebloblangds" {
  name                = "cde_blob_lang_ds"
  data_factory_id     = var.data_factory_id
  linked_service_name = var.linked_service_name

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "clean"
    filename  = "language.csv"
  }
}

resource "azurerm_data_factory_dataset_delimited_text" "cdeblobcountriesds" {
  name                = "cde_blob_countries_ds"
  data_factory_id     = var.data_factory_id
  linked_service_name = var.linked_service_name

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "clean"
    filename  = "country_info.csv"
  }
}
