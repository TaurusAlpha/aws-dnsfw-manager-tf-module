provider "aws" {
  alias  = "assume-root"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.root_acc}:role/${var.tf_role}"
  }
}

provider "aws" {
  alias  = "assume-inspection"
  region = var.home_region
  assume_role {
    role_arn = "arn:aws:iam::${var.inspection_acc}:role/${var.tf_role}"
  }
}