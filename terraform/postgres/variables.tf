variable "location" {
  type = string
}

variable "resource_group_name" {
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