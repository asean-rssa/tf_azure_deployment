resource "azurerm_databricks_workspace" "example" {
  name                = "${local.prefix}-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"
  tags                = local.tags
  custom_parameters {
    no_public_ip         = var.no_public_ip
    storage_account_name = local.dbfsname
  }
}

output "databricks_azure_workspace_resource_id" {
  // The ID of the Databricks Workspace in the Azure management plane.
  value = azurerm_databricks_workspace.example.id
}

output "workspace_url" {
  // The workspace URL which is of the format 'adb-{workspaceId}.{random}.azuredatabricks.net'
  // this is not named as DATABRICKS_HOST, because it affect authentication
  value = "https://${azurerm_databricks_workspace.example.workspace_url}/"
}
