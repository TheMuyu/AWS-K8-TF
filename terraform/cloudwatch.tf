resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/aws/eks/backend"
  retention_in_days = 30

  tags = {
    Environment = "dev"
    Application = "backend"
  }
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/aws/eks/frontend"
  retention_in_days = 30

  tags = {
    Environment = "dev"
    Application = "frontend"
  }
}
