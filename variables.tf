# Bootstrap backend and iam

locals {
  environment = "central-bootstrap-local" # no workspace yet
  creator     = "Terraform ${local.environment} ${var.profile}"
}

#### Connection information

variable region {
  type = string
}
variable profile {
  type = string
}
variable profile_credentials_file {
  type = string
}

#### Resources to be used

variable "vc_repo_name" {
  description = "version control name of and existing repo"
  type        = string
}

variable "main_policy" {
  description = "an existing policy with which Terraform will perform AWS services management"
  default     =  "AdministratorAccess" # AWS managed AdministratorAccess
}

variable "output_dir" {
  description = "folder into which the scripts will be written"
  type        = string
  default     = "./out"
}

variable "local_cidr_block" {
  description = "authorized CIDR block"
  type        = string
}


#### Resources to be created :

variable "shared_s3_bucket" {
  description = "variables for shared_s3_bucket module"
  type        = object({
      bucket_name = string
      policy_name = string
      ou_path     = string
      description = string
  })
}

variable "admin_role" {
  description = "variables for admin_role module"
  type        = object({
      name        = string
      ou_path     = string
      description = string
  })
}

variable "policies" {
  description = "names of the policies to be created"
  type        = object({
    vc_policy_name        = string
    pass_role_policy_name = string
  })
}

variable "backend_config_file_name" {
  description = "Backend config file name for subsequent connections"
  default     = "var-backend.auto.tfvars"
}
