variable "dbvnetcidr" {
  type    = string
  default = "10.179.0.0/20"
}
variable "rglocation" {
  type    = string
  default = "southeastasia"
}

variable "workspace_prefix" {
  type    = string
  default = "adb"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

# the 2 vars below must be the same to packer config, hardcoded for now
variable "managed_image_name" {
  type    = string
  default = "coldstart-gibujk-image"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "coldstart-gibujk-rg"
}
