output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnets
}

output "security_group_id_backend" {
  description = "Security group ID for backend"
  value       = aws_security_group.backend_sg.id
}

output "security_group_id_rds" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds_sg.id
}