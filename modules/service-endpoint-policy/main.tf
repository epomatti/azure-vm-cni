resource "azurerm_subnet_service_endpoint_storage_policy" "storage" {
  name                = "cni-storage-se-policy"
  resource_group_name = var.resource_group_name
  location            = var.location

  definition {
    name        = "cni-storage"
    description = "Allows access to the the storage in this CNI project."
    service     = "Microsoft.Storage"

    service_resources = [
      var.storage_account_id
    ]
  }

  definition {
    name        = "aliases"
    description = "Aliases"
    service     = "Global"

    service_resources = [
      "/services/Azure",
      "/services/Azure/Batch",
      "/services/Azure/DataFactory",
      "/services/Azure/MachineLearning",
      "/services/Azure/ManagedInstance",
      "/services/Azure/WebPI",
    ]
  }

}
