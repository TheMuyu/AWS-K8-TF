vpc_name           = "task-ce-vpc-prod"
vpc_cidr           = "10.1.0.0/16"
rds_instance_class = "db.t3.medium"
environment        = "prod"
db_secret_name = "db-credentials-3"
alb_hosted_zone_id  = "Z215JYRZR1TBD5" #eu-central-1

public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.101.0/24", "10.1.102.0/24"]
aws_region           = "eu-central-1"
azs                  = ["eu-central-1a", "eu-central-1b"]

alert_email_address = "muratyurtdas@gmail.com"

enable_alb_module              = true
enable_bastion_module          = true
enable_eks_module              = true
enable_rds_module              = true
enable_state_module            = false
enable_vpc_module              = true
enable_watch_module            = false
enable_nat_gateway             = true
enable_rds_enhanced_monitoring = true
rds_monitoring_interval        = 60

cluster_name              = "task-ce-eks-cluster-prod"
cluster_version           = "1.31"
eks_node_instance_type    = "t3.medium"
eks_node_desired_capacity = 2
eks_node_min_size         = 2
eks_node_max_size         = 4

tf_state_bucket_name    = "aws-k8-tf-state-prod"
tf_state_dynamodb_table = "aws-k8-tf-locks-prod"
