output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = module.db.db_instance_endpoint
}

output "replica_db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance."
  value       = module.db_replica[*].db_instance_endpoint
}

output "db_instance_name" {
  description = "Name of the database instance"
  value       = module.db.db_instance_identifier
}

output "replica_db_instance_name" {
  description = "Name of the replica database s"
  value       = module.db_replica[*].db_instance_identifier
}

output "db_instance_username" {
  description = "Master username for accessing the database."
  value       = nonsensitive(module.db.db_instance_username)
}

output "db_instance_password" {
  description = "Password for accessing the database."
  value       = var.custom_user_password != "" ? var.custom_user_password : nonsensitive(random_password.master[0].result)
}

output "master_credential_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = aws_secretsmanager_secret.secret_master_db.arn
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
