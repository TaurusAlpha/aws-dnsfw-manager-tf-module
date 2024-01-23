terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.root,
        aws.delegated_fms_admin_acc,
      ]
    }
  }
}