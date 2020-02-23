variable "user_name" {
  description = "an existing user used to assume role"
  type        = string # "iac-admin"
}

variable "main_policy" {
  description = "an existing policy"
  type        = string 
}
