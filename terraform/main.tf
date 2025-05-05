
module "vpc" {
  count  = var.enable_vpc_module ? 1 : 0
  source = "./modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
  enable_nat_gateway   = var.enable_nat_gateway
}

module "eks" {
  count  = var.enable_eks_module ? 1 : 0
  source = "./modules/eks"

  vpc_id                    = module.vpc[0].vpc_id
  private_subnet_ids        = module.vpc[0].private_subnets
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  eks_node_instance_type    = var.eks_node_instance_type
  eks_node_desired_capacity = var.eks_node_desired_capacity
  eks_node_min_size         = var.eks_node_min_size
  eks_node_max_size         = var.eks_node_max_size

  depends_on = [module.vpc]
}

module "bastion" {
  count  = var.enable_bastion_module ? 1 : 0
  source = "./modules/bastion"

  vpc_id           = module.vpc[0].vpc_id
  public_subnet_id = module.vpc[0].public_subnets[0]

  depends_on = [module.vpc]
}

module "rds" {
  count  = var.enable_rds_module ? 1 : 0
  source = "./modules/rds"

  vpc_id             = module.vpc[0].vpc_id
  private_subnet_ids = module.vpc[0].private_subnets

  eks_node_sg_id                 = module.eks[0].node_security_group_id
  bastion_sg_id                  = module.bastion[0].bastion_sg_id
  rds_instance_class             = var.rds_instance_class
  enable_rds_enhanced_monitoring = var.enable_rds_enhanced_monitoring
  rds_monitoring_interval        = var.rds_monitoring_interval
  db_secret_name                 = var.db_secret_name
  environment                    = var.environment

  depends_on = [
    module.vpc,
    module.eks,
    module.bastion
  ]
}

module "alb" {
  count  = var.enable_alb_module ? 1 : 0
  source = "./modules/alb"

  vpc_id            = module.vpc[0].vpc_id
  aws_region        = var.aws_region
  cluster_name      = var.cluster_name
  oidc_provider_url = module.eks[0].oidc_provider_url
  oidc_provider_arn = module.eks[0].oidc_provider_arn

  acm_domain_name    = "app.muratyurtdas.com"
  alb_hosted_zone_id = var.alb_hosted_zone_id
  environment = var.environment

  depends_on = [module.eks]
}

module "watch" {
  count  = var.enable_watch_module ? 1 : 0
  source = "./modules/watch"

  cluster_name        = module.eks[0].cluster_name
  oidc_provider_url   = module.eks[0].oidc_provider_url
  oidc_provider_arn   = module.eks[0].oidc_provider_arn
  aws_region          = var.aws_region
  alert_email_address = var.alert_email_address

  depends_on = [module.eks]
}

module "state" {
  count  = var.enable_state_module ? 1 : 0
  source = "./modules/state"

  tf_state_bucket_name    = var.tf_state_bucket_name
  tf_state_dynamodb_table = var.tf_state_dynamodb_table
  environment             = var.environment
}
