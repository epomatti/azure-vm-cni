resource "random_string" "storage_name" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "default" {
  name                      = "st${var.workload}${random_string.storage_name.result}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  # Networking
  public_network_access_enabled = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.public_ip_address_to_allow]
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = ["AzureServices"]
  }
}
