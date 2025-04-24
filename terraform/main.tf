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

  eks_cluster_sg_id = module.eks.cluster_security_group_id
  bastion_sg_id     = module.bastion.bastion_sg_id
}

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  region             = var.aws_region
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
  tags = {
    Name = "task-ce-hosted"
  }
}

resource "aws_route53_record" "nginx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.muratyurtdas.com"
  type    = "A"

  alias {
    name                   = "k8s-test-nginxing-d1a7d572bb-815771783.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K" # This is the hosted zone ID for ALB in us-east-1
    evaluate_target_health = true
  }
}
