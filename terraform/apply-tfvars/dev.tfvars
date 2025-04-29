vpc_name = "task-ce-vpc-dev"
vpc_cidr = "10.0.0.0/16"
rds_instance_class = "db.t3.micro"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

alert_email_address = "muratyurtdas@gmail.com"
enable_watch_module = false

cluster_name    = "task-ce-eks-cluster"
cluster_version = "1.31"
eks_node_instance_type = "t3.medium"
eks_node_desired_capacity = 2
eks_node_min_size = 1
eks_node_max_size = 3
