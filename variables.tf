variable "home_region" {
  type = string
}

variable "root_acc" {
  type = string
}

variable "delegated_fms_admin_acc" {
  type = string
}

variable "tf_role" {
  type = string
}

variable "domain_blacklist" {
  type    = set(string)
  default = ["example.com", "*.example.com"]
}