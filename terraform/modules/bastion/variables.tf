variable "vpc_id" {
  description = "VPC id where bastion will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet id for bastion"
  type        = string
}

variable "key_name" {
  description = "SSH Key name for EC2"
  type        = string
  default     = "task-ce-bastion-key"
}
