variable "vpc_id" {
  description = "VPC id where bastion will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id for bastion (should be public subnet)"
  type        = string
}

variable "key_name" {
  description = "SSH Key name for EC2"
  type        = string
  default     = "task-ce-bastion-key"
}
