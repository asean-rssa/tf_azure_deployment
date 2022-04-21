locals {
  prefix   = join("-", [var.workspace_prefix, "${random_string.naming.result}"])
  location = var.rglocation
  dbcidr   = var.dbvnetcidr
  // for metastore
  db_url            = "jdbc:sqlserver://${azurerm_mssql_server.metastoreserver.name}.database.windows.net:1433;database=${azurerm_mssql_database.sqlmetastore.name};user=${var.db_username}@${azurerm_mssql_server.metastoreserver.name};password={${var.db_password}};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
  db_username_local = var.db_username
  db_password_local = var.db_password
  // tags that are propagated down to all resources
  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
    Epoch       = random_string.naming.result
  }
}
