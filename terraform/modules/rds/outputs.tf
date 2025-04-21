output "rds_endpoint" {
  description = "RDS Endpoint address"
  value       = module.rds.db_instance_endpoint
}

output "rds_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}