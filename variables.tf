variable "location" {
  type    = string
  default = "westus2"
}

variable "no_public_ip" {
  type    = bool
  default = true
}

variable "namespace" {
  type    = string
  default = "meaningless_name"
}