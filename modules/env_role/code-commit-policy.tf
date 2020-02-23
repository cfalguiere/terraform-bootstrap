/*
  Create a code commit access policy
*/

data "aws_iam_policy_document" "vc_policy_document" {

  statement {
    sid = "query"

    effect = "Allow"

    actions = [
      "codecommit:ListRepositoriesForApprovalRuleTemplate",
      "codecommit:CreateApprovalRuleTemplate",
      "codecommit:UpdateApprovalRuleTemplateName",
      "codecommit:GetApprovalRuleTemplate",
      "codecommit:ListApprovalRuleTemplates",
      "codecommit:DeleteApprovalRuleTemplate",
      "codecommit:ListRepositories",
      "codecommit:UpdateApprovalRuleTemplateContent",
      "codecommit:UpdateApprovalRuleTemplateDescription"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "repo"

    effect = "Allow"

    actions = [
      "codecommit:*"
    ]

    resources = [
      var.parent_context.vc_repo.arn
    ]
  }
}

# create a policy with the document
resource "aws_iam_policy" "vc_policy" {
  name        = var.parent_context.vc_policy_name
  path        = var.ou_path
  description = "Access to Terraform S3 bucket"
  policy      = data.aws_iam_policy_document.vc_policy_document.json
}
