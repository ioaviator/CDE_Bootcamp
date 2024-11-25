variable "data_factory_id" {
  type = string
}

variable "db_admin_login" {
  type = string
  sensitive = true
  default = "adminadmin"
}

variable "db_admin_pass" {
  type = string
  sensitive = true
  default = "12345678He/"
}