vpc_name = "task-ce-vpc-prod"
vpc_cidr = "10.1.0.0/16"
rds_instance_class = "db.t3.medium"

public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.101.0/24", "10.1.102.0/24"]

alert_email_address = "muratyurtdas@gmail.com"
enable_watch_module = true

cluster_name    = "task-ce-eks-cluster"
cluster_version = "1.31"
eks_node_instance_type = "t3.medium"
eks_node_desired_capacity = 2
eks_node_min_size = 2
eks_node_max_size = 4
