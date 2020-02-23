/*
  Create assume role policy
*/

# create a policy JSON document allowing the user and ec2 to assume a role

data "aws_iam_policy_document" "trust_policy_document" {

  statement {
    sid = "tftrust" # underscore not supported

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
