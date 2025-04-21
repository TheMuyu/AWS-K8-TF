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
  backend_sg_id = aws_security_group.backend_sg.id

  eks_cluster_sg_id  = module.eks.cluster_security_group_id
}

module "eks" {
  source = "./modules/eks"

  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}