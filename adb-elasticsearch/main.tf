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

locals {
  // dltp - databricks labs terraform provider
  prefix   = join("-", [var.workspace_prefix, "${random_string.naming.result}"])
  location = var.rglocation
  cidr     = var.spokecidr
  dbfsname = join("", [var.dbfs_prefix, "${random_string.naming.result}"]) // dbfs name must not have special chars

  // tags that are propagated down to all resources
  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
    Epoch       = random_string.naming.result
  }
}

resource "azurerm_resource_group" "this" {
  name     = "adb-splunk-${local.prefix}-rg"
  location = local.location
  tags     = local.tags
}

// step 1 create storage account and container from module
module "adls_content" {
  source                   = "./modules/adls_content"
  rg                       = azurerm_resource_group.this.name
  storage_account_location = var.rglocation
}

// step 2 create local file of bootstrap scripts, explicitly depends_on adls container
resource "local_file" "setupscript" {
  content         = <<EOT
  #! /bin/bash
  sudo apt update
  sudo apt install docker.io -y
  sudo apt install docker-compose -y
  sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:8.3.2
  sudo docker network create elastic
  sudo docker run --name es01 --net elastic -p 9200:9200 -p 9300:9300 -it docker.elastic.co/elasticsearch/elasticsearch:8.3.2
  EOT
  filename        = "splunk_setup.sh"
  file_permission = "0777" // default value 0777

  depends_on = [
    module.adls_content
  ]
}

// step 3 upload scripts and artifacts onto container, explicitly depends_on script to be generated first at local
resource "azurerm_storage_blob" "splunk_setup_file" {
  name                   = "splunk_setup.sh"
  storage_account_name   = module.adls_content.storage_name
  storage_container_name = module.adls_content.container_name
  type                   = "Block"
  source                 = "${path.root}/splunk_setup.sh"

  depends_on = [
    local_file.setupscript
  ]
}

resource "azurerm_storage_blob" "splunk_databricks_app_file" {
  name                   = "databricks-add-on-for-splunk_110.tgz"
  storage_account_name   = module.adls_content.storage_name
  storage_container_name = module.adls_content.container_name
  type                   = "Block"
  source                 = "${path.root}/artifacts/databricks-add-on-for-splunk_110.tgz"

  depends_on = [
    local_file.setupscript
  ]
}
