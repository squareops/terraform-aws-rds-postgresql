output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = module.db.db_instance_endpoint
}

output "db_instance_name" {
  description = "Name of the database instance"
  value       = module.db.db_instance_name
}

output "db_instance_username" {
  description = "Master username for accessing the database."
  value       = nonsensitive(module.db.db_instance_username)
}

output "db_instance_password" {
  description = "Password for accessing the database (Note: Terraform does not track this password after initial creation)."
  value       = nonsensitive(module.db.db_instance_password)
}

output "rds_dedicated_security_group" {
  description = "ID of the security group associated with the RDS instance."
  value       = module.security_group_rds.security_group_id
}

output "db_parameter_group_id" {
  description = "ID of the parameter group associated with the RDS instance."
  value       = module.db.db_parameter_group_id
}

output "db_subnet_group_id" {
  description = "ID of the subnet group associated with the RDS instance."
  value       = module.db.db_subnet_group_id
}
