# return bucket

output "current_bucket" {
  value       = aws_s3_bucket.current
  description = "Current bucket"
}

output "current_policy" {
  value       = aws_iam_policy.list_and_access_all
  description = "Current bucket policy"
}
