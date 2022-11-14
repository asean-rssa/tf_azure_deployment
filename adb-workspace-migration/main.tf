provider "azurerm" {
  features {}
}

provider "random" {
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

resource "azurerm_resource_group" "migration_rg" {
  name     = "workspace-migration-rg-hwang"
  location = "Southeast Asia"
}

resource "azurerm_databricks_workspace" "example" {
  name                = "databricks-test"
  resource_group_name = azurerm_resource_group.migration_rg.name
  location            = azurerm_resource_group.migration_rg.location
  sku                 = "premium"

  tags = {
    Environment = "Development"
  }
}

resource "azurerm_databricks_workspace" "newws" {
  name                = "databricks-new-ws-test"
  resource_group_name = azurerm_resource_group.migration_rg.name
  location            = azurerm_resource_group.migration_rg.location
  sku                 = "premium"

  tags = {
    Environment = "Development"
  }
}

resource "databricks_service_principal" "sp" {
  application_id       = "e1d820e9-68eb-4e7b-8684-b6ed9d7c6974"
  display_name         = "Example service principal"
  allow_cluster_create = true
}
