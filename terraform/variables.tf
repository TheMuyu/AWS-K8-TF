variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "rds_instance_class" {
  description = "Instance class/type for RDS"
  type        = string
}

variable "alert_email_address" {
  description = "CloudWatch Alert Email Address"
  type        = string
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
}

variable "eks_node_desired_capacity" {
  description = "Desired number of EKS worker nodes"
  type        = number
}

variable "eks_node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
}

variable "eks_node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "tf_state_bucket_name" {
  description = "S3 bucket name to store Terraform state"
  type        = string
}

variable "tf_state_dynamodb_table" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnet internet access"
  type        = bool
}

variable "azs" {
  description = "List of availability zones to use in the region"
  type        = list(string)
}

variable "enable_rds_enhanced_monitoring" {
  description = "Whether to enable Enhanced Monitoring for RDS"
  type        = bool
}

variable "rds_monitoring_interval" {
  description = "Monitoring interval in seconds (e.g. 1, 5, 10, 15, 30, 60)"
  type        = number
}

variable "db_secret_name" {
  description = "AWS Secret DB Credentials Name"
  type        = string
}

# Enable or disable the ALB (Application Load Balancer) module
variable "enable_alb_module" {
  description = "Whether to enable the ALB module for external HTTP(S) load balancing"
  type        = bool
}

# Enable or disable the Remote State Management module (e.g., S3 backend)
variable "enable_state_module" {
  description = "Whether to enable the remote state backend module (e.g., S3 for state storage)"
  type        = bool
}


# Enable or disable the CloudWatch monitoring/observability module
variable "enable_watch_module" {
  description = "Whether to enable the Watch module (CloudWatch agent, logging, monitoring stack)"
  type        = bool
}

variable "alb_hosted_zone_id" {
  description = "ALB Route53 hosted zone ID"
  type        = string
}