
# return role

output "current" {
  value       = aws_iam_role.current
  description = "Current role"
}
