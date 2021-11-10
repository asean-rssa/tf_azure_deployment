resource "azurerm_key_vault" "akv1" {
  name                        = "${local.prefix}-akv"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.akv1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  # must use lowercase letters in permission
  key_permissions = [
    "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore"
  ]

  secret_permissions = [
    "get", "list", "delete", "recover", "backup", "restore", "set"
  ]
}


resource "databricks_secret_scope" "kv" {
  # akv backed
  name = "hive"

  keyvault_metadata {
    resource_id = azurerm_key_vault.akv1.id
    dns_name    = azurerm_key_vault.akv1.vault_uri
  }
}

resource "azurerm_key_vault_secret" "hiveurl" {
  name         = "HIVE-URL"
  value        = "test1"
  key_vault_id = azurerm_key_vault.akv1.id
}

resource "azurerm_key_vault_secret" "hiveuser" {
  name         = "HIVE-USER"
  value        = "test2"
  key_vault_id = azurerm_key_vault.akv1.id
}

resource "azurerm_key_vault_secret" "hivepwd" {
  name         = "HIVE-PASSWORD"
  value        = "test3"
  key_vault_id = azurerm_key_vault.akv1.id
}