terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.84.0"
    }
  }
}

locals {
  workload = "cni"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "mssql" {
  source   = "./modules/mssql"
  workload = local.workload
  group    = azurerm_resource_group.default.name
  location = azurerm_resource_group.default.location

  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  public_ip_address_to_allow    = var.public_ip_address_to_allow
  public_network_access_enabled = var.mssql_public_network_access_enabled
  admin_admin                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
  default_subnet_id             = module.vnet.vnet_id
}

module "vm" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet.subnet_id
  size                = var.vm_size
}

module "storage" {
  source                     = "./modules/storage"
  workload                   = local.workload
  resource_group_name        = azurerm_resource_group.default.name
  location                   = azurerm_resource_group.default.location
  vnet_id                    = module.vnet.vnet_id
  subnet_id                  = module.vnet.subnet_id
  public_ip_address_to_allow = var.public_ip_address_to_allow
}

module "keyvault" {
  source                      = "./modules/keyvault"
  workload                    = local.workload
  resource_group_name         = azurerm_resource_group.default.name
  location                    = azurerm_resource_group.default.location
  subnet_id                   = module.vnet.subnet_id
  public_ip_addresses_allowed = [var.public_ip_address_to_allow]
  mssql_admin_login           = var.mssql_admin_login
  mssql_admin_login_password  = var.mssql_admin_login_password
  storage_connection_string   = module.storage.primary_blob_connection_string
}
