

# create a bucket

resource "aws_s3_bucket" "current" {
  bucket = var.bucket_name
  acl = "private"

  tags = {
    Name        = var.bucket_name
    Description = var.description
    Environment = var.parent_context.common_tags.environment
    Created-By  = var.parent_context.common_tags.creator
  }
}

# block all public access to bucket

resource "aws_s3_bucket_public_access_block" "current_block_all" {
  bucket = aws_s3_bucket.current.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
