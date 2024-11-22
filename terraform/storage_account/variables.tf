
variable "storage_account_name" {
  type = string
}
variable "storage_container" {
  type = string
  description = "container for extracted data from api"
}

variable "location" {
  type = string
  description = "Geographic location where resources are deployed"
}

variable "resource_group" {
  description = "resource group container where deployed services are grouped"
}
