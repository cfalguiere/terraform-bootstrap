
# lookup the codecommit repo

data "aws_codecommit_repository" "selected_vc" {
  repository_name = var.repo_name
}
