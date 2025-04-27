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
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
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