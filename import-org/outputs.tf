# output "org_member_account_ids" {
#   description = "List of all organization member accounts ids"
#   value       = data.aws_organizations_organization.aws_org.accounts[*].id
# }

# output "org_member_account_emails" {
#   description = "List of all orgamization member accounts emails"
#   value = data.aws_organizations_organization.aws_org.accounts[*].email
# }

# output "org_member_accounts" {
#   value = data.aws_organizations_organization.aws_org.accounts
# }

output "org_id" {
  value = data.aws_organizations_organization.aws_org.roots[0].id
}