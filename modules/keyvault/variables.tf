variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "public_ip_addresses_allowed" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type      = string
  sensitive = true
}

variable "storage_connection_string" {
  type      = string
  sensitive = true
}
