terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = try(module.eks[0].cluster_endpoint, null)
  cluster_ca_certificate = try(base64decode(module.eks[0].cluster_certificate_authority_data), null)
  token                  = try(data.aws_eks_cluster_auth.eks_cluster_auth[0].token, null)
}

provider "helm" {
  kubernetes {
    host                   = try(module.eks[0].cluster_endpoint, null)
    cluster_ca_certificate = try(base64decode(module.eks[0].cluster_certificate_authority_data), null)
    token                  = try(data.aws_eks_cluster_auth.eks_cluster_auth[0].token, null)
  }
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  count = var.enable_eks_module ? 1 : 0
  name  = module.eks[0].cluster_name
}

#State pointing remote dev
# terraform {
#   backend "s3" {
#     bucket         = "aws-k8-tf-state-dev"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "aws-k8-tf-locks-dev"
#     encrypt        = true
#   }
# }

#State pointing remote prod
# terraform {
#   backend "s3" {
#     bucket         = "aws-k8-tf-state-prod"
#     key            = "prod/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "aws-k8-tf-locks-prod"
#     encrypt        = true
#   }
# }