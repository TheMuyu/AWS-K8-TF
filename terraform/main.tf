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
}

# Fetch the ALB DNS dynamically
# data "kubernetes_ingress" "frontend_ingress" {
#   metadata {
#     name      = "frontend-ingress"
#     namespace = "frontend"
#   }
# }

# resource "aws_route53_record" "frontend" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "app.muratyurtdas.com"
#   type    = "A"

#   alias {
#     name                   = data.kubernetes_ingress.frontend_ingress.status.load_balancer.ingress[0].hostname
#     zone_id                = "Z35SXDOTRQ7X7K" # us-east-1 ALB Hosted Zone ID
#     evaluate_target_health = true
#   }
# }

#kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# resource "helm_release" "fluentbit" {
#   name       = "aws-for-fluent-bit"
#   namespace  = "kube-system"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-for-fluent-bit"
#   version    = "0.1.35"

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "fluent-bit"
#   }

#   set {
#     name  = "cloudWatch.enabled"
#     value = "true"
#   }

#   set {
#     name  = "cloudWatch.region"
#     value = var.aws_region
#   }

#   set {
#     name  = "cloudWatch.logGroupTemplate"
#     value = "/eks/$kubernetes['namespace_name']"
#   }

#   set {
#     name  = "cloudWatch.logStreamPrefix"
#     value = "eks-logs"
#   }

#   set {
#     name  = "cloudWatch.logRetentionDays"
#     value = "7"
#   }

#   set {
#     name  = "firehose.enabled"
#     value = "false"
#   }

#   set {
#     name  = "elasticsearch.enabled"
#     value = "false"
#   }

#   set {
#     name  = "kinesis.enabled"
#     value = "false"
#   }
# }

# resource "aws_cloudwatch_log_group" "backend_log_group" {
#   name              = "/eks/backend"
#   retention_in_days = 7
# }

# resource "aws_cloudwatch_log_group" "frontend_log_group" {
#   name              = "/eks/frontend"
#   retention_in_days = 7
# }

