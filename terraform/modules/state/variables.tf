variable "tf_state_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "tf_state_dynamodb_table" {
  description = "DynamoDB table name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}