output "instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds-pg.db_instance_endpoint
}

output "instance_name" {
  description = "The database name"
  value       = module.rds-pg.db_instance_name
}

output "instance_username" {
  description = "The master username for the database"
  value       = module.rds-pg.db_instance_username
}

output "instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.rds-pg.db_instance_password
}

output "security_group" {
  description = "The security group ID of the cluster"
  value       = module.rds-pg.rds_dedicated_security_group
}

output "parameter_group_id" {
  description = "The db parameter group id"
  value       = module.rds-pg.db_parameter_group_id
}

output "subnet_group_id" {
  description = "The db subnet group name"
  value       = module.rds-pg.db_subnet_group_id
}