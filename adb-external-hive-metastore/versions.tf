# versions.tf
terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.10"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.83.0"
    }
  }
}