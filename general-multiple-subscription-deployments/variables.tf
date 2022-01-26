variable "second_subscription_id" {
  type    = string
  default = "xxxxxx-xxxx-xxxx-xxxx-xxxxxx" // you can specify runtime variables to overwrite default
}

variable "rglocation" {
    type = string
    default = "southeastasia"
}

variable "workspace_prefix" {
    type = string
    default = "Workspace"
}