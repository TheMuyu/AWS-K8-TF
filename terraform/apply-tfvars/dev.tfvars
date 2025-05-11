vpc_name           = "task-ce-vpc-dev"
vpc_cidr           = "10.0.0.0/16"
rds_instance_class = "db.t3.micro"
environment        = "dev"
db_secret_name = "db-credentials-5"
alb_hosted_zone_id  = "Z215JYRZR1TBD5" #eu-central-1

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
aws_region           = "eu-central-1"
azs                  = ["eu-central-1a", "eu-central-1b"]

alert_email_address = "muratyurtdas@gmail.com"

enable_alb_module              = true
enable_state_module            = false
enable_watch_module            = false

enable_nat_gateway             = true
enable_rds_enhanced_monitoring = false
rds_monitoring_interval        = 60

cluster_name              = "task-ce-eks-cluster-dev"
cluster_version           = "1.31"
eks_node_instance_type    = "t3.small"
eks_node_desired_capacity = 1
eks_node_min_size         = 1
eks_node_max_size         = 2

tf_state_bucket_name    = "aws-k8-tf-state-dev"
tf_state_dynamodb_table = "aws-k8-tf-locks-dev"
