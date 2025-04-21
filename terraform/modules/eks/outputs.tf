output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_group_role_arn" {
  value = module.eks.eks_managed_node_groups.default_node_group.iam_role_arn
}