locals {
  name              = "keyvault"
  dns_zone_name     = "privatelink.vaultcore.azure.net"
  subresource_names = ["vault"]
}

resource "azurerm_private_dns_zone" "default" {
  name                = local.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${local.name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

resource "azurerm_private_endpoint" "default" {
  name                = "pe-${local.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.default.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.default.id
    ]
  }

  private_service_connection {
    name                           = local.name
    private_connection_resource_id = var.resource_id
    is_manual_connection           = false
    subresource_names              = local.subresource_names
  }
}
