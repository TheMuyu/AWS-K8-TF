resource "aws_iam_role" "eks_node_group_role" {
  name = "task-ce-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # EKS managed node groups
  eks_managed_node_groups = {
    default_node_group = {
      instance_types = [var.eks_node_instance_type]
      desired_size   = var.eks_node_desired_capacity
      min_size       = var.eks_node_min_size
      max_size       = var.eks_node_max_size

      iam_role_arn = aws_iam_role.eks_node_group_role.arn
      # iam_role_additional_policies = {
      #   CloudWatchAgentPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      # }
    }
  }

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  enable_irsa                     = true
  cluster_enabled_log_types       = []    # disables control plane logs
  create_cloudwatch_log_group     = false # disables log group creation
}

locals {
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = replace(module.eks.oidc_provider, "https://", "")
}
