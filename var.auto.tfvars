#### Connection information :

# choose a region
region = "eu-west-3"

# choose the admin user
# make sure the user exists and has the policy AdministratorAccess
profile  = "my-admin"

# choose the aws credentials file
profile_credentials_file  = "<your-home>/.aws/credentials"

#### Resources to be used

# choose an existing policy codecommit repository
vc_repo_name  = "central"

# choose an authorized CIDR block
local_cidr_block = "<your-ip>/32"


#### Resources to be created :

shared_s3_bucket = {
  bucket_name = "iac-terraform-workspaces"
  policy_name = "iac_workspaces_s3_policy"
  ou_path     = "/central/"
  description = "Terraform shared resources"
}

admin_role = {
  name        = "IAC-AI_Demos"
  ou_path     = "/central/"
  description = "Admin Role"
}

policies = {
  vc_policy_name        = "iac_infra_code_commit_policy"
  pass_role_policy_name = "iac_pass_role_user_policy"
}
