output "instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = module.rds-pg.db_instance_endpoint
}
output "replica_instances_endpoints" {
  description = "Connection endpoint of the RDS replica instances."
  value       = module.rds-pg.replica_db_instance_endpoint
}

output "instance_name" {
  description = "Name of the database instance."
  value       = module.rds-pg.db_instance_name
}

output "db_name" {
  description = "Database name"
  value       = module.rds-pg.db_name
}

output "rds-mysql_replica_db_instance_name" {
  description = "The name of the database instance"
  value       = module.rds-pg.replica_db_instance_name
}

output "instance_username" {
  description = "Master username for accessing the database."
  value       = module.rds-pg.db_instance_username
}

output "instance_password" {
  description = "Password for accessing the database (Note: Terraform does not track this password after initial creation)."
  value       = module.rds-pg.db_instance_password
  sensitive   = false
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

output "master_user_secret_arn" {
  value = module.rds-pg.master_credential_secret_arn
}
