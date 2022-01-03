variable "vnetcidr" {
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

# the 2 vars below must be the same to packer config
variable "managed_image_name" {
  type    = string
  default = "hwangnonansibleimage"
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "hwang-adb-kr"
}
