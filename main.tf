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

resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_resource_group" "default" {
  name     = local.namespace
  location = var.location
}

locals {
  namespace = substr(join("-", [var.namespace, random_string.rand.result]), 0, 24)
}