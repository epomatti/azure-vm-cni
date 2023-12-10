data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                     = "kv-${var.workload}789"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  public_network_access_enabled = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.public_ip_addresses_allowed
    virtual_network_subnet_ids = [var.subnet_id]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Delete", "Get", "List", "Set", "Purge"]
  }
}

resource "azurerm_key_vault_secret" "sql_database_admin_username" {
  name         = "mssqlusername"
  value        = var.mssql_admin_login
  key_vault_id = azurerm_key_vault.default.id
}

resource "azurerm_key_vault_secret" "sql_database_admin_password" {
  name         = "mssqlpassword"
  value        = var.mssql_admin_login_password
  key_vault_id = azurerm_key_vault.default.id
}

resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "storageconnectionstring"
  value        = var.storage_connection_string
  key_vault_id = azurerm_key_vault.default.id
}
