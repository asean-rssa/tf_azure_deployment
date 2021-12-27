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

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

resource "azurerm_resource_group" "this" {
  name     = "adb-squid-${local.prefix}-rg"
  location = local.location
  tags     = local.tags
}
