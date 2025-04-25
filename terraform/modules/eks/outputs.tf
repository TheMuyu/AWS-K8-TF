output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "node_group_role_arn" {
  value = module.eks.eks_managed_node_groups.default_node_group.iam_role_arn
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider
}

output "alb_sa_role_arn" {
  value = aws_iam_role.alb_sa_role.arn
}