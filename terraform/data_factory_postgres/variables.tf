variable "data_factory_id" {
  type = string
}

variable "db_admin_login" {
  type = string
  sensitive = true
  default = "adminad"
}

variable "db_admin_pass" {
  type = string
  sensitive = true
  default = "123456/"
}