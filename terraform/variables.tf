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

  validation {
    condition     = !(var.enable_alb_module && (!var.enable_vpc_module || !var.enable_eks_module))
    error_message = "ALB module requires both VPC and EKS modules to be enabled."
  }
}

# Enable or disable the Bastion host module
variable "enable_bastion_module" {
  description = "Whether to enable the Bastion module to SSH into private subnets or access RDS"
  type        = bool

  validation {
    condition     = !(var.enable_bastion_module && !var.enable_vpc_module)
    error_message = "Bastion module requires the VPC module to be enabled."
  }
}

# Enable or disable the EKS (Elastic Kubernetes Service) module
variable "enable_eks_module" {
  description = "Whether to enable the EKS module to provision the Kubernetes cluster"
  type        = bool

  validation {
    condition     = !(var.enable_eks_module && !var.enable_vpc_module)
    error_message = "EKS module requires the VPC module to be enabled."
  }
}

# Enable or disable the RDS (PostgreSQL) module
variable "enable_rds_module" {
  description = "Whether to enable the RDS module to provision a managed PostgreSQL instance"
  type        = bool

  validation {
    condition     = !(var.enable_rds_module && (!var.enable_vpc_module || !var.enable_bastion_module))
    error_message = "RDS module requires VPC and Bastion modules to be enabled."
  }
}

# Enable or disable the Remote State Management module (e.g., S3 backend)
variable "enable_state_module" {
  description = "Whether to enable the remote state backend module (e.g., S3 for state storage)"
  type        = bool
}

# Enable or disable the VPC networking module
variable "enable_vpc_module" {
  description = "Whether to enable the VPC module to create core networking (subnets, routes, IGW)"
  type        = bool
}

# Enable or disable the CloudWatch monitoring/observability module
variable "enable_watch_module" {
  description = "Whether to enable the Watch module (CloudWatch agent, logging, monitoring stack)"
  type        = bool

  validation {
    condition     = !(var.enable_watch_module && !var.enable_eks_module)
    error_message = "Watch module requires the EKS module to be enabled."
  }
}

variable "alb_hosted_zone_id" {
  description = "ALB Route53 hosted zone ID"
  type        = string
}