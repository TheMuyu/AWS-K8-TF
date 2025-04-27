resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks"
  retention_in_days = 30

  tags = {
    Environment = "Dev"
    Application = "eks-cluster-logs"
  }
}

#Create SNS Topic
resource "aws_sns_topic" "alerts_topic" {
  name = "eks-alerts-topic"
}

# Subscribe your email address to the SNS topic
resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email_address  # Define this in your variables.tf
}

# CloudWatch Alarm: High CPU Usage on EKS Nodes
resource "aws_cloudwatch_metric_alarm" "high_node_cpu" {
  alarm_name          = "High-Node-CPU-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Node CPU utilization is over 80% for 2 minutes"
  dimensions = {
    ClusterName = "task-ce-eks-cluster"
  }
  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  tags = {
    Environment = "dev"
  }
}

# CloudWatch Alarm: Pod CrashLoop (Pods in Failed State)
resource "aws_cloudwatch_metric_alarm" "pod_crash_loop" {
  alarm_name          = "Pod-CrashLoop-Detected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "pod_status_failed"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "One or more pods are in CrashLoop or Failed state"
  dimensions = {
    ClusterName = "task-ce-eks-cluster"
  }
  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  tags = {
    Environment = "dev"
  }
}