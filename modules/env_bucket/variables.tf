variable "bucket_name" {
  description = "the bucket name"
  type        = string
}

variable "description" {
  description = "the bucket description"
  type        = string
}

variable "policy_name" {
  description = "the name of the shared bucket policy"
  type        = string
}

variable "ou_path" {
  description = "the path inside IAM names"
  type        = string
}

variable "parent_context" {
  description = "useful vars to share with the child module"
  type = object({
      common_tags   = object({
                            environment = string
                            creator = string
                          })
  })
}
