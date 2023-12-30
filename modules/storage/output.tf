output "primary_blob_connection_string" {
  value = azurerm_storage_account.default.primary_blob_connection_string
}

output "storage_account_id" {
  value = azurerm_storage_account.default.id
}
