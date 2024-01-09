data "external" "get_managed_malware_rslvr_id" {
  program = ["sh", "-c", "aws route53resolver list-firewall-domain-lists | jq '.FirewallDomainLists[] | select(.Name == \"AWSManagedDomainsMalwareDomainList\") | {id: .Id}'"]
}

data "external" "get_managed_botnet_rslvr_id" {
  program = ["sh", "-c", "aws route53resolver list-firewall-domain-lists | jq '.FirewallDomainLists[] | select(.Name == \"AWSManagedDomainsBotnetCommandandControl\") | {id: .Id}'"]
}

data "external" "get_managed_threat_rslvr_id" {
  program = ["sh", "-c", "aws route53resolver list-firewall-domain-lists | jq '.FirewallDomainLists[] | select(.Name == \"AWSManagedDomainsAggregateThreatList\") | {id: .Id}'"]
}