output "rslvr_malware_id" {
  value = data.external.get_managed_malware_rslvr_id.result["id"]
}

output "rslvr_botnet_id" {
  value = data.external.get_managed_botnet_rslvr_id.result["id"]
}

output "rslvr_threat_id" {
  value = data.external.get_managed_threat_rslvr_id.result["id"]
}