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

#RDS
output "rds_endpoint" {
  description = "The connection endpoint for the RDS database instance."
  value       = module.rds.rds_endpoint
}

output "rds_sg_id" {
  description = "The ID of the security group associated with the RDS instance."
  value       = module.rds.security_group_id_rds
}

#EKS
output "eks_cluster_endpoint" {
  description = "Endpoint URL for the EKS Kubernetes API server."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_sg_id" {
  description = "Security group ID associated with the EKS cluster control plane."
  value       = module.eks.cluster_security_group_id
}

#Bastion
output "bastion_public_ip" {
  description = "Public IP address of the Bastion host instance."
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_key_pem" {
  description = "Private key (.pem) for connecting to the Bastion host. (Sensitive output)"
  value       = module.bastion.bastion_private_key_pem
  sensitive   = true
}

output "db_credentials" {
  value = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
  sensitive = true
}

output "db_secret_name" {
  value = data.aws_secretsmanager_secret.db_credentials.name
}