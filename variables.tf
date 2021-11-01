variable "hubcidr" {
  type    = string
  default = "10.178.0.0/20"
}

variable "spokecidr" {
  type    = string
  default = "10.179.0.0/20"
}

variable "no_public_ip" {
  default = true
}

variable "rglocation" {
  type    = string
  default = "southeastasia"
}

variable "dbfs_prefix" {
  type    = string
  default = "dbfs"
}

variable "workspace_prefix" {
  type    = string
  default = "adb"
}

variable "firewallfqdn" {
  type = list(any)
  default = [                                                           // we don't need scc relay and dbfs fqdn since they will go to private endpoint
    "dbartifactsprodseap.blob.core.windows.net",                        //databricks artifacts
    "dbartifactsprodeap.blob.core.windows.net",                         //databricks artifacts secondary
    "dblogprodseasia.blob.core.windows.net",                            //log blob
    "prod-southeastasia-observabilityeventhubs.servicebus.windows.net", //eventhub
    "cdnjs.com",                                                        //ganglia
  ]
}
