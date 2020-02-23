
output "admin_user" {
  value       = data.aws_iam_user.selected
  description = "Selected user"
}

output "base_policy" {
  value       = data.aws_iam_policy.base_policy
  description = "Base policy"
}
