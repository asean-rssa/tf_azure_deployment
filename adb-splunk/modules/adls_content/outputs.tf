output "storage_name" {
  value = azurerm_storage_account.personaldropbox.name
}

output "container_name" {
  value = azurerm_storage_container.container1.name
}
