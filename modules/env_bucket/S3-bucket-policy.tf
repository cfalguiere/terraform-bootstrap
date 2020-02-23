# create a  JSON document for the bucket policy
# basic share bucket policy (list, read, write all objets of the bucket)

data "aws_iam_policy_document" "list_and_access_all" {

  statement {
    sid = "access"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      format( "%s/*" , aws_s3_bucket.current.arn ),
      aws_s3_bucket.current.arn
    ]
  }

}

# create a policy with the document

resource "aws_iam_policy" "list_and_access_all" {
  name        = var.policy_name
  path        = var.ou_path
  description = "LIst/Read/Write for bucket ${var.bucket_name}"
  policy      = data.aws_iam_policy_document.list_and_access_all.json
}
