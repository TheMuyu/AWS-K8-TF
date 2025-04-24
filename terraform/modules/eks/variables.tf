variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where nodes will be placed"
  type        = list(string)
}

variable "region" {
  type = string
}