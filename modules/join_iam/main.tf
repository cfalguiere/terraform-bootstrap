
# lookup a user

data "aws_iam_user" "selected" {
  user_name = var.user_name
}

# lookup base policy for admin profile

data "aws_iam_policy" "base_policy" {
  arn = "arn:aws:iam::aws:policy/${var.main_policy}"
}
