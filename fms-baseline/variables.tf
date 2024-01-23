variable "delegated_fms_admin_acc" {
  type = string
}

variable "org_ou" {
  type = string
}

variable "aws_aggregate_threat_domain_list_id" {
  type = string
}

variable "aws_botnet_domain_list_id" {
  type = string
}

variable "aws_malware_domain_list_id" {
  type = string
}

variable "aws_guardduty_domain_list_id" {
  type = string
}

variable "domain_blacklist" {
  type = list(string)
  default = [""]
}