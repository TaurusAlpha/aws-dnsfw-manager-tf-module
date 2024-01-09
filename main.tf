module "import-org" {
  source = "./import-org"

  providers = {
    aws.root = aws.assume-root
  }
}

module "route53_managed_rules" {
  source = "./route53-managed-rules"

  providers = {
    aws.src = aws.assume-inspection
  }
}

module "fms_baseline" {
  source = "./fms-baseline"

  providers = {
    aws.root = aws.assume-root
    aws.inspection = aws.assume-inspection
  }

  inspection_acc = var.inspection_acc
  org_ou = module.import-org.org_id
  aws_aggregate_threat_domain_list_id = module.route53_managed_rules.rslvr_threat_id
  aws_botnet_domain_list_id = module.route53_managed_rules.rslvr_botnet_id
  aws_malware_domain_list_id = module.route53_managed_rules.rslvr_malware_id
}