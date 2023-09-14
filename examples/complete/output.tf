output "instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = module.rds-pg.db_instance_endpoint
}

output "instance_name" {
  description = "Name of the database instance."
  value       = module.rds-pg.db_instance_name
}

output "instance_username" {
  description = "Master username for accessing the database."
  value       = module.rds-pg.db_instance_username
}

output "instance_password" {
  description = "Password for accessing the database (Note: Terraform does not track this password after initial creation)."
  value       = module.rds-pg.db_instance_password
}

output "security_group" {
  description = "ID of the security group associated with the RDS instance."
  value       = module.rds-pg.rds_dedicated_security_group
}

output "parameter_group_id" {
  description = "ID of the parameter group associated with the RDS instance."
  value       = module.rds-pg.db_parameter_group_id
}

output "subnet_group_id" {
  description = "ID of the subnet group associated with the RDS instance."
  value       = module.rds-pg.db_subnet_group_id
}
