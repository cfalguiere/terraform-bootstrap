terraform {
  required_version = ">= 0.12.18"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile  = var.profile
  shared_credentials_file = var.profile_credentials_file
}

locals {
  common_tags = {
    environment = terraform.workspace
    creator     = "Terraform ${terraform.workspace} ${var.profile}"
  }
}

/*
  sub modules
*/

# lookup a admin user

module "selected_admin_user" {
  source = "./modules/join_iam"

  user_name = var.profile
  main_policy = var.main_policy
}

# lookup a repo

module "selected_vc_repo" {
  source = "./modules/join_codecommit"

  repo_name = var.vc_repo_name
}

# create a shared bucket for terraform

module "shared_s3_bucket" {
  source = "./modules/env_bucket"

  bucket_name = var.shared_s3_bucket.bucket_name
  policy_name = var.shared_s3_bucket.policy_name
  ou_path     = var.shared_s3_bucket.ou_path
  description = var.shared_s3_bucket.description

  parent_context =  {
      common_tags = local.common_tags
  }

}

# create a role dedicated to terraform operations

module "admin_role" {
  source = "./modules/env_role"

  name        = var.admin_role.name
  ou_path     = var.admin_role.ou_path
  description = var.admin_role.description

  parent_context =  {
      common_tags           = local.common_tags
      user_profile          = module.selected_admin_user.admin_user
      base_policy           = module.selected_admin_user.base_policy
      bucket_policy         = module.shared_s3_bucket.current_policy
      vc_repo               = module.selected_vc_repo.selected_repo
      vc_policy_name        = var.policies.vc_policy_name
      pass_role_policy_name = var.policies.pass_role_policy_name
  }

}

# output backend config file

module "backend_config" {
  source = "./modules/backend_config"

  file_name = var.backend_config_file_name
  output_dir = var.output_dir

  parent_context =  {
      common_tags = local.common_tags
      admin_role  = module.admin_role.current
      region      = var.region
      profile             = var.profile
      profile_credentials = var.profile_credentials_file
      shared_s3_bucket    = module.shared_s3_bucket.current_bucket
  }

}
