variable "vpc_id" {
  description = "VPC ID where RDS should be deployed"
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class/type for RDS database"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Optional Security group ID of the bastion host"
  type        = string
  default     = null
}

variable "eks_node_sg_id" {
  description = "Optional EKS Node Security Group ID"
  type        = string
  default     = null
}

variable "enable_rds_enhanced_monitoring" {
  description = "Whether to enable Enhanced Monitoring for RDS"
  type        = bool
}

variable "rds_monitoring_interval" {
  description = "Monitoring interval in seconds (e.g. 1, 5, 10, 15, 30, 60)"
  type        = number
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "db_secret_name" {
  description = "AWS Secret DB Credentials Name"
  type        = string
}