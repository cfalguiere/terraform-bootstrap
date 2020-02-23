# Bootstrap backend and iam

/*
  Create aa local file - this file contains the backend configuration for later use
*/

locals {
  generated_config_file = "${var.output_dir}/var-backend.auto.tfvars"
}

resource "local_file" "backend_config" {
    content         = templatefile("${path.module}/templates/var-backend-tfvars.tmpl",
                        {
                            producer            = var.parent_context.common_tags.creator
                            profile             = var.parent_context.profile
                            profile_credentials = var.parent_context.profile_credentials
                            admin_role_name     = var.parent_context.admin_role.name
                            admin_role_arn      = var.parent_context.admin_role.arn
                            backend_bucket      = var.parent_context.shared_s3_bucket.name
                            region              = var.parent_context.region
                        }
                    )
    filename        = local.generated_config_file
    file_permission = "0600" # u=rw
}
