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
    value = var.region
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
