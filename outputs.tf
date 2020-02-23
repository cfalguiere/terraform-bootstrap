# this file contains the backend configuration for subsequent plans

output "log_local_file_backend_config" {
  value       = module.backend_config.filename
  description = "Generated configuration file"
}
