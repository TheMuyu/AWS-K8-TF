variable "vpc_id" {
  description = "VPC ID where RDS should be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "backend_sg_id" {
  description = "Security Group ID of the backend application to allow DB access"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "EKS Cluster security group ID"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  type        = string
}