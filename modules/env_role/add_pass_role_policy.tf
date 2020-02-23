# Bootstrap backend and iam
# PassRole policy

/*
  Create pass role policy and attach ot to the admin user
  This policy allow the user to attach a role to an EC2 instance
*/

data "aws_iam_policy_document" "pass_role_policy_document" {

  statement {
    sid = "allow"

    effect = "Allow"

    actions = [
      "iam:PassRole",
      "iam:ListInstanceProfiles",
      "ec2:*"
    ]

    resources = [
      "*"
    ]
  }
}

# create a policy with the document
resource "aws_iam_policy" "pass_role_policy" {
  name        = var.parent_context.pass_role_policy_name
  path        = var.ou_path
  description = "Allow PassRole to a user"
  policy      = data.aws_iam_policy_document.pass_role_policy_document.json
}

# add policy to admin user
resource "aws_iam_user_policy_attachment" "pass_role_to_admin" {
  user       = var.parent_context.user_profile.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}
