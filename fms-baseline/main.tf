resource "aws_fms_admin_account" "fms_admin" {
  provider   = aws.root
  account_id = var.inspection_acc
}

resource "aws_fms_policy" "fms_baseline_policy" {
  depends_on = [aws_fms_admin_account.fms_admin]
  provider   = aws.inspection

  name                               = "fms-mofa-baseline"
  exclude_resource_tags              = false
  remediation_enabled                = true
  resource_type                      = "AWS::EC2::VPC"
  delete_unused_fm_managed_resources = true

  include_map {
    orgunit = [ var.org_ou ]
  }

  security_service_policy_data {
    type = "DNS_FIREWALL"

    managed_service_data = jsondecode({
      type = "DNS_FIREWALL"

      preProcessRuleGroups = {
        priority    = 1
        ruleGroupId = aws_route53_resolver_firewall_rule_group.global_rule_group.id
      }
    })
  }
}

resource "aws_route53_resolver_firewall_rule_group" "global_rule_group" {
  provider = aws.inspection
  name     = "fwdns-rule-group-global-dns-blacklist"
}

resource "aws_route53_resolver_firewall_domain_list" "blacklist_domain_list" {
  provider = aws.inspection
  name     = "fwdns-list-global-blacklist"
  domains  = ["cnn.com"]
}

resource "aws_route53_resolver_firewall_rule" "global_blacklist_rule" {
  provider                = aws.inspection
  name                    = "fwdns-rule-global-blacklist"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.blacklist_domain_list
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.global_rule_group.id
  priority                = 100
}

resource "aws_route53_resolver_firewall_rule" "managed_malware" {
  provider                = aws.inspection
  name                    = "fwdns-rule-global-managed-malware"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_malware_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.global_rule_group.id
  priority                = 1
}

resource "aws_route53_resolver_firewall_rule" "managed_botnet" {
  provider                = aws.inspection
  name                    = "fwdns-rule-global-managed-botnet"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_botnet_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.global_rule_group.id
  priority                = 2
}

resource "aws_route53_resolver_firewall_rule" "managed_aggregate_threat" {
  provider                = aws.inspection
  name                    = "fwdns-rule-global-managed-threat"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_aggregate_threat_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.global_rule_group.id
  priority                = 3
}
