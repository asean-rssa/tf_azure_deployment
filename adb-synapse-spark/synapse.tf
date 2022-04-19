resource "azurerm_storage_account" "synapse" {
  name                     = join("", ["synapsestorage", "${random_string.naming.result}"])
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "synapseadls" {
  name               = join("", ["synapsestorageadls", "${random_string.naming.result}"])
  storage_account_id = azurerm_storage_account.synapse.id
}

resource "azurerm_synapse_workspace" "synapsews" {
  name                                 = join("-", ["synapsews", "${random_string.naming.result}"])
  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.synapseadls.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"
  managed_virtual_network_enabled      = true
}

resource "azurerm_synapse_firewall_rule" "example" {
  name                 = "allowAll"
  synapse_workspace_id = azurerm_synapse_workspace.synapsews.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

resource "azurerm_synapse_linked_service" "example" {
  name                 = "example"
  synapse_workspace_id = azurerm_synapse_workspace.synapsews.id
  type                 = "AzureBlobStorage"
  type_properties_json = <<JSON
{
  "connectionString": "${azurerm_storage_account.synapse.primary_connection_string}"
}
JSON

  depends_on = [
    azurerm_synapse_firewall_rule.example,
  ]
}

resource "azurerm_synapse_linked_service" "sqldb" {
  name                 = "externalmetastorelinkedservice"
  synapse_workspace_id = azurerm_synapse_workspace.synapsews.id
  type                 = "AzureSqlDatabase"
  type_properties_json = <<JSON
{
  "connectionString": "Data Source=tcp:${azurerm_mssql_server.metastoreserver.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.sqlmetastore.name};User ID=azureuser;Password=Vadim778!;Trusted_Connection=False;Encrypt=True;Connection Timeout=30"
}
JSON

  depends_on = [
    azurerm_synapse_firewall_rule.example,
  ]
}
