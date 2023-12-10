variable "location" {
  type    = string
  default = "eastus2"
}

variable "public_ip_address_to_allow" {
  type = string
}

### Virtual Machine ###
variable "vm_size" {
  type = string
}

### SQL Database ###
variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type      = string
  sensitive = true
}

variable "mssql_public_network_access_enabled" {
  type = bool
}
