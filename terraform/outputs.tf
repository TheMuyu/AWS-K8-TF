output "vpc_id" {
  description = "VPC ID"
  value       = try(module.vpc[0].vpc_id, null)
}

# RDS
output "rds_endpoint" {
  description = "The connection endpoint for the RDS database instance."
  value       = try(module.rds[0].rds_endpoint, null)
}

output "rds_sg_id" {
  description = "The ID of the security group associated with the RDS instance."
  value       = try(module.rds[0].security_group_id_rds, null)
}

# EKS
output "eks_cluster_endpoint" {
  description = "Endpoint URL for the EKS Kubernetes API server."
  value       = try(module.eks[0].cluster_endpoint, null)
}

output "eks_node_sg_id" {
  description = "Security group ID associated with the EKS Node control plane."
  value       = try(module.eks[0].node_security_group_id, null)
}

# Bastion
output "bastion_public_ip" {
  description = "Public IP address of the Bastion host instance."
  value       = try(module.bastion[0].bastion_public_ip, null)
}

output "bastion_private_key_pem" {
  description = "Private key (.pem) for connecting to the Bastion host. (Sensitive output)"
  value       = try(module.bastion[0].bastion_private_key_pem, null)
  sensitive   = true
}

# output "hosted_zone_id" {
#   description = "The ID of the Route53 Hosted Zone."
#   value       = aws_route53_zone.main.zone_id
# }

# output "route53_nameservers" {
#   description = "The list of Route53 nameservers for the hosted zone."
#   value       = aws_route53_zone.main.name_servers
# }