
variable "resource_group_name" {
  description = "resource group container for all deployed azure services"
  default     = "cde_resource"
}

variable "storage_account_name" {
  description = "storage account name for data lake"
  default     = "cdedestorage"
}

variable "raw_storagecontainer" {
  description = "container for extracted data from api"
  default     = "raw"
}