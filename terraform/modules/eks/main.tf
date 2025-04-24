resource "aws_iam_policy" "alb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/alb_controller_policy.json")
}

resource "aws_iam_role" "alb_sa_role" {
  name = "eks-alb-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = local.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  role       = aws_iam_role.alb_sa_role.name
  policy_arn = aws_iam_policy.alb_controller.arn
}



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

  cluster_name    = "task-ce-eks-cluster"
  cluster_version = "1.31"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # EKS managed node groups
  eks_managed_node_groups = {
    default_node_group = {
      instance_types = ["t3.micro"]
      min_size     = 2
      max_size     = 4
      desired_size = 3

      iam_role_arn = aws_iam_role.eks_node_group_role.arn
    }
  }

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  enable_irsa = true
}

locals {
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = replace(module.eks.oidc_provider, "https://", "")
}


