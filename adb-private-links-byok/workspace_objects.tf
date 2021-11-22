provider "databricks" {
  host = azurerm_databricks_workspace.this.workspace_url
}

data "databricks_node_type" "smallest" {
  local_disk = true
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  depends_on = [
    azurerm_databricks_workspace.this
  ]
}


resource "databricks_cluster" "coldstart" {
  cluster_name            = "coldstart_cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 2
  }
  depends_on = [
    azurerm_databricks_workspace.this
  ]
}
