resource "aws_iam_role" "eks_fluentbit_irsa_role" {
  name = "eks-fluentbit-irsa-role"

  assume_role_policy = data.aws_iam_policy_document.eks_fluentbit_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_fluentbit_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:fluent-bit"]
    }
  }
}

resource "aws_iam_role_policy" "eks_fluentbit_irsa_policy" {
  name = "eks-fluentbit-irsa-policy"
  role = aws_iam_role.eks_fluentbit_irsa_role.id

  policy = data.aws_iam_policy_document.eks_fluentbit_cloudwatch_policy.json
}

data "aws_iam_policy_document" "eks_fluentbit_cloudwatch_policy" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "kubernetes_service_account" "fluentbit" {
  metadata {
    name      = "fluent-bit"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_fluentbit_irsa_role.arn
    }
    labels = {
      "app.kubernetes.io/name"      = "fluent-bit"
      "app.kubernetes.io/instance"  = "aws-for-fluent-bit"
    }
  }
}

resource "helm_release" "aws_for_fluent_bit" {
  name       = "aws-for-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  namespace  = "kube-system"
  version    = "0.1.35"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "fluent-bit"
  }

  set {
    name  = "cloudWatch.region"
    value = var.aws_region
  }

  set {
    name  = "cloudWatch.logGroupName"
    value = "/aws/eks"
  }

  set {
    name  = "cloudWatch.logStreamPrefix"
    value = "$kubernetes['namespace_name']/"
  }

  set {
    name  = "cloudWatch.enabled"
    value = "true"
  }
}


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
    ClusterName = var.cluster_name
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
    ClusterName = var.cluster_name
  }
  alarm_actions = [aws_sns_topic.alerts_topic.arn]
  tags = {
    Environment = "dev"
  }
}