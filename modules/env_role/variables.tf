
variable "name" {
  description = "the role name"
  type        = string
}

variable "description" {
  description = "the role description"
  type        = string
}

variable "ou_path" {
  description = "the path inside IAM names"
  type        = string
}

variable "parent_context" {
  description = "useful vars to share with the child module"
  type = object({
      common_tags     = object({
                            environment = string
                            creator = string
                          })
      user_profile          = any
      base_policy           = any
      bucket_policy         = any
      vc_repo               = any
      vc_policy_name        = string
      pass_role_policy_name = string
  })
}
