module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

resource "aws_security_group" "backend_sg" {
  name        = "task-ce-backend_sg"
  description = "Allow inbound traffic on port 8080 from public subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow TCP 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  backend_sg_id      = aws_security_group.backend_sg.id

  eks_node_sg_id     = module.eks.node_security_group_id
  bastion_sg_id      = module.bastion.bastion_sg_id
  rds_instance_class = var.rds_instance_class
}

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  eks_node_instance_type    = var.eks_node_instance_type
  eks_node_desired_capacity = var.eks_node_desired_capacity
  eks_node_min_size         = var.eks_node_min_size
  eks_node_max_size         = var.eks_node_max_size
}

module "bastion" {
  source = "./modules/bastion"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id

  depends_on = [module.eks]
}

module "watch" {
  source = "./modules/watch"

  count = var.enable_watch_module ? 1 : 0

  cluster_name        = module.eks.cluster_name
  oidc_provider_url   = module.eks.oidc_provider_url
  oidc_provider_arn   = module.eks.oidc_provider_arn
  aws_region          = var.aws_region
  alert_email_address = var.alert_email_address

  depends_on = [module.eks]
}

module "state" {
  source = "./modules/state"

  count = var.enable_state_module ? 1 : 0

  tf_state_bucket_name    = var.tf_state_bucket_name
  tf_state_dynamodb_table = var.tf_state_dynamodb_table
  environment             = var.environment
}

resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.eks.alb_sa_role_arn
    }
  }
}

resource "helm_release" "alb_ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.10.0"
  depends_on = [kubernetes_service_account.alb_sa]

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "image.tag"
    value = "v2.12.0"
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}

resource "aws_route53_zone" "main" {
  name = "muratyurtdas.com"
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.muratyurtdas.com"
  type    = "A"

  alias {
    name                   = "k8s-frontendingressgr-0493fcecd1-293296825.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K" # us-east-1 ALB Hosted Zone ID
    evaluate_target_health = true
  }
}
