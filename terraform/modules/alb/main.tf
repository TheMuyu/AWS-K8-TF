resource "aws_iam_policy" "alb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/alb_controller_policy.json")
}

resource "aws_iam_role" "alb_sa_role" {
  name = "eks-alb-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  role       = aws_iam_role.alb_sa_role.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_sa_role.arn
    }
  }
}

resource "helm_release" "alb_ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.10.0"
  depends_on = [kubernetes_service_account.alb_sa]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "image.tag"
    value = "v2.12.0"
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}

resource "aws_route53_zone" "main" {
  name = "muratyurtdas.com"
}

resource "kubernetes_namespace" "frontend" {
  metadata {
    name = "frontend"
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.frontend.metadata[0].name
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "frontend_ingress" {
  metadata {
    name      = "frontend-ingress"
    namespace = kubernetes_namespace.frontend.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/certificate-arn"          = aws_acm_certificate_validation.this.certificate_arn
      "alb.ingress.kubernetes.io/ssl-policy"               = "ELBSecurityPolicy-2016-08"
      "alb.ingress.kubernetes.io/group.name"               = "frontend-ingress-group"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=60"
      "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
    }
  }

  spec {
    rule {
      host = "app.muratyurtdas.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

data "external" "ingress_hostname" {
  program = ["powershell", "-Command", <<EOT
  $hostname = kubectl get ingress frontend-ingress -n frontend -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
  Write-Output "{`"hostname`": `"$hostname`"}"
EOT
  ]
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.muratyurtdas.com"
  type    = "A"

  alias {
    name                   = data.external.ingress_hostname.result.hostname
    zone_id                = var.alb_hosted_zone_id # eu-central-1 hosted zone ID for ALB
    evaluate_target_health = true
  }

  depends_on = [kubernetes_ingress_v1.frontend_ingress]
}


resource "aws_acm_certificate" "this" {
  domain_name       = var.acm_domain_name
  validation_method = "DNS"

  tags = {
    Name        = "app-cert"
    Environment = var.environment
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
