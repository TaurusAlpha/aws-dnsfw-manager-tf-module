resource "aws_fms_admin_account" "fms_admin" {
  provider   = aws.root
  account_id = var.delegated_fms_admin_acc
}

resource "aws_fms_policy" "fms_baseline_policy" {
  depends_on = [aws_fms_admin_account.fms_admin]
  provider   = aws.delegated_fms_admin_acc

  name                               = "fms-mofa-baseline"
  exclude_resource_tags              = false
  remediation_enabled                = true
  resource_type                      = "AWS::EC2::VPC"
  delete_unused_fm_managed_resources = true

  security_service_policy_data {
    type = "DNS_FIREWALL"

    managed_service_data = jsonencode({
      type = "DNS_FIREWALL"

      preProcessRuleGroups = [{
        ruleGroupId = aws_route53_resolver_firewall_rule_group.managed_global_rule_group.id
        priority    = 1
      }],
      postProcessRuleGroups = [{
        ruleGroupId = aws_route53_resolver_firewall_rule_group.global_rule_group.id
        priority    = 9901
      }]
    })
  }
}

resource "aws_route53_resolver_firewall_rule_group" "global_rule_group" {
  provider = aws.delegated_fms_admin_acc
  name     = "fwdns-rule-group-global-dns-blacklist"
}

resource "aws_route53_resolver_firewall_rule_group" "managed_global_rule_group" {
  provider = aws.delegated_fms_admin_acc
  name     = "fwdns-rule-group-managed-global-dns-blacklist"
}

resource "aws_route53_resolver_firewall_domain_list" "blacklist_domain_list" {
  provider = aws.delegated_fms_admin_acc
  name     = "fwdns-list-global-blacklist"
  domains  = var.domain_blacklist
}

resource "aws_route53_resolver_firewall_rule" "global_blacklist_rule" {
  depends_on = [aws_route53_resolver_firewall_domain_list.blacklist_domain_list]

  provider = aws.delegated_fms_admin_acc

  name                    = "fwdns-rule-global-blacklist"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.blacklist_domain_list.id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.global_rule_group.id
  priority                = 100
}

resource "aws_route53_resolver_firewall_rule" "managed_malware" {
  provider                = aws.delegated_fms_admin_acc
  name                    = "fwdns-rule-managed-global-malware"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_malware_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.managed_global_rule_group.id
  priority                = 1
}

resource "aws_route53_resolver_firewall_rule" "managed_botnet" {
  provider                = aws.delegated_fms_admin_acc
  name                    = "fwdns-rule-managed-global-botnet"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_botnet_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.managed_global_rule_group.id
  priority                = 2
}

resource "aws_route53_resolver_firewall_rule" "managed_aggregate_threat" {
  provider                = aws.delegated_fms_admin_acc
  name                    = "fwdns-rule-managed-global-threat"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_aggregate_threat_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.managed_global_rule_group.id
  priority                = 3
}

resource "aws_route53_resolver_firewall_rule" "managed_guardduty_threat" {
  provider                = aws.delegated_fms_admin_acc
  name                    = "fwdns-rule-managed-global-guardduty"
  action                  = "BLOCK"
  block_response          = "NXDOMAIN"
  firewall_domain_list_id = var.aws_guardduty_domain_list_id
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.managed_global_rule_group.id
  priority                = 4
}
