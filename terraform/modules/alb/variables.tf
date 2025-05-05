variable "vpc_id" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "acm_domain_name" {
  description = "The domain name to issue ACM cert for"
  type        = string
}

variable "alb_hosted_zone_id" {
  description = "ALB Route53 Hosted Zone ID for ACM validation"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

