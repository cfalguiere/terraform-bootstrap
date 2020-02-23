variable "file_name" {
  description = "the file name"
  type        = string
}

variable "output_dir" {
  description = "the folder name"
  type        = string
}

variable "parent_context" {
  description = "useful vars to share with the child module"
  type = object({
      common_tags   = object({
                            environment = string
                            creator = string
                          })
      admin_role          = any
      region              = string
      profile             = string
      profile_credentials = string
      shared_s3_bucket    = any
  })
}
