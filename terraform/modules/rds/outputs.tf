output "rds_endpoint" {
  description = "RDS Endpoint address"
  value       = module.rds.db_instance_endpoint
}

output "rds_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "security_group_id_rds" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds_sg.id
}