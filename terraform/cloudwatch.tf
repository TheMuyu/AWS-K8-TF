resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks"
  retention_in_days = 30

  tags = {
    Environment = "Dev"
    Application = "eks-cluster-logs"
  }
}