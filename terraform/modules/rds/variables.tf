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