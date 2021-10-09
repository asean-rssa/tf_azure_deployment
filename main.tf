// terraform detailed versions of providers
terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.2.5"
    }
    azurerm = {
      version = "~>2.0"
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = local.rand_namespace
  location = var.location
}

resource "random_string" "rand_rg_name" {
  length  = 4
  special = false
  upper   = false
}

resource "random_string" "adbrand" {
  special = false
  upper   = false
  length  = 5
}

# local variables
locals {
  rand_namespace = join("-", [var.namespace, random_string.rand_rg_name.result])
  prefix         = "workshop-${random_string.adbrand.result}"
  location       = var.location
  // tags that are propagated down to all resources
  tags = {
    Environment = "Testing"
    Epoch       = random_string.adbrand.result
  }
}

resource "azurerm_databricks_workspace" "this" {
  sku                         = "premium"
  name                        = "${local.prefix}-workspace"
  managed_resource_group_name = "${local.prefix}-workspace-rg"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location

  custom_parameters {
    no_public_ip = var.no_public_ip
  }

  tags = local.tags
}