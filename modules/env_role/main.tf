
# Create the role

resource "aws_iam_role" "current" {
  name               = var.name
  path               = var.ou_path
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy_document.json

  tags = {
    Name        = var.name
    Description = var.description
    Environment = var.parent_context.common_tags.environment
    Created-By  = var.parent_context.common_tags.creator
  }
}

# create a JSON document allowing ec2  to assume a role

data "aws_iam_policy_document" "ec2_trust_policy_document" {

 statement {
   sid = "trustec2"

   effect = "Allow"

   actions = [
     "sts:AssumeRole"
   ]

   principals {
     type        = "AWS"
     identifiers = [ var.parent_context.user_profile.arn ]
   }

   principals {
     type        = "Service"
     identifiers = [ "ec2.amazonaws.com" ]
   }
 }

}

# Attach policies

# add AdministratorAccess policy to the provisioner role
resource "aws_iam_role_policy_attachment" "provisioning_full_access" {
  role       = aws_iam_role.current.name
  policy_arn = var.parent_context.base_policy.arn
}

# add bucket policy to the  role
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.current.name
  policy_arn = var.parent_context.bucket_policy.arn
}

# add VC repo access to the provisioner role
# add bucket policy to the provisioner role
resource "aws_iam_role_policy_attachment" "provisioning_vc_access" {
  role       = aws_iam_role.current.name
  policy_arn = aws_iam_policy.vc_policy.arn
}
