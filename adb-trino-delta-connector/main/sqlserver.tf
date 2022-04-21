resource "azurerm_storage_account" "sqlserversa" {
  name                     = "${random_string.naming.result}sqlserversa"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS" // LRS 3 copies of data in the region
}

resource "azurerm_mssql_server" "metastoreserver" {
  name                          = "${random_string.naming.result}mssqlserver"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  version                       = "12.0"
  administrator_login           = var.db_username // sensitive data stored as env variables locally
  administrator_login_password  = var.db_password
  public_network_access_enabled = true // consider to disable public access to the server, to set as false
}

resource "azurerm_mssql_database" "sqlmetastore" {
  name           = "${random_string.naming.result}metastore"
  server_id      = azurerm_mssql_server.metastoreserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  read_scale     = true
  max_size_gb    = 4
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
  tags           = local.tags

}

resource "azurerm_mssql_server_extended_auditing_policy" "mssqlpolicy" {
  server_id                               = azurerm_mssql_server.metastoreserver.id
  storage_endpoint                        = azurerm_storage_account.sqlserversa.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.sqlserversa.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}


resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "allow-all-azure-services"
  server_id        = azurerm_mssql_server.metastoreserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
