# versions.tf
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.6.5"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.83.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
  }
}
