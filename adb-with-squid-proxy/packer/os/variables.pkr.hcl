# using interaction az login authentication, only need to specify subscription id
variable "subscription_id" {
  type = string
  default = "3f2e4d32-8e8d-46d6-82bc-5bb8d962328b"
}

variable "managed_img_rg_name" {
  type = string
  default = "hwang-adb-kr"
}

variable "managed_img_name" {
  type = string
  default = "hwangtestpackerimg2"
}