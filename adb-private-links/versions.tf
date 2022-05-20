# versions.tf
terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">=0.5.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.83.0"
    }
  }
}
