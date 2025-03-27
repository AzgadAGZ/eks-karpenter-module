module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_external_dns = var.enable_external_dns
  external_dns = {
    name          = "external-dns"
    chart_version = var.external_dns_chart_version
    repository    = "https://kubernetes-sigs.github.io/external-dns/"
    namespace     = "external-dns"

    values = [
      <<-EOT
        topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: capacity-spread
          whenUnsatisfiable: DoNotSchedule      
      EOT
    ]

    set = [
      {
        name  = "revisionHistoryLimit"
        value = 1
      },
      {
        name  = "extraArgs[0]"
        value = "--aws-prefer-cname"
      },
      {
        name  = "extraArgs[1]"
        value = "--txt-prefix=${var.external_dns_txt_prefix}"
      },
      {
        name  = "extraArgs[2]"
        value = "--txt-owner-id=${var.external_dns_txt_owner_id}"
      },
      {
        name  = "extraArgs[3]"
        value = "--domain-filter=${var.external_dns_domain_filter}"
      }
    ]
  }

  external_dns_route53_zone_arns = ["arn:aws:route53:::hostedzone/${var.external_dns_hosted_zone_id}"]

  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller = {
    chart_version = var.aws_load_balancer_controller_chart_version

    values = [
      <<-EOT
        tolerations:
        - key: "karpenter.sh/controller"
          value: "true"
          operator: Equal
          effect: NoSchedule
        topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: capacity-spread
          whenUnsatisfiable: ScheduleAnyway      
      EOT
    ]

    set = [
      {
        name  = "revisionHistoryLimit"
        value = 1
      }
    ]
  }

  enable_metrics_server = var.enable_metrics_server
  metrics_server = {
    chart_version = "3.12.1"

    values = [
      <<-EOT
        topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: capacity-spread
          whenUnsatisfiable: DoNotSchedule      
      EOT
    ]

    set = [
      {
        name  = "revisionHistoryLimit"
        value = 1
      }
    ]
  }

  enable_cert_manager = var.enable_cert_manager
  cert_manager = {
    chart_version = var.cert_manager_chart_version

    values = [
      <<-EOT
        revisionHistoryLimit: 1
        crds:
          enable: true
        serviceAccount:
          name: cert-manager
          annotations:
            eks.amazonaws.com/role-arn: ${aws_iam_role.cert_manager_iam_role.arn}
        securityContext:
          fsGroup: 1001
        topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: capacity-spread
          whenUnsatisfiable: DoNotSchedule  
        webhook:
          topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: capacity-spread
            whenUnsatisfiable: DoNotSchedule
        cainjector:
          topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: capacity-spread
            whenUnsatisfiable: DoNotSchedule
        startupapicheck:
          topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: capacity-spread
            whenUnsatisfiable: DoNotSchedule    
      EOT
    ]
  }


  enable_external_secrets = var.enable_external_secrets
  external_secrets = {
    chart_version = "0.9.20"
    namespace     = "external-secrets"

    values = [
      <<-EOT
        global:
          topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: capacity-spread
            whenUnsatisfiable: DoNotSchedule      
      EOT
    ]

    set = [
      {
        name  = "revisionHistoryLimit"
        value = 1
      },
      {
        name  = "webhook.serviceAccount.name"
        value = var.eso_service_account_name
      },
      {
        name  = "webhook.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = module.eso_iam_role.iam_role_arn
      }
    ]
  }

  tags = var.tags

  depends_on = [
    aws_iam_role.cert_manager_iam_role
  ]
}

resource "kubectl_manifest" "eso_cluster_store" {
  provider = kubectl
  yaml_body = templatefile("${path.module}/external-secrets-templates/cluster-store.tftpl", {
    eso_cluster_store_name   = var.eso_cluster_store_name,
    aws_region               = var.aws_region,
    eso_service_account_name = var.eso_service_account_name,
  })

  depends_on = [module.eks_blueprints_addons]
}

resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  provider = kubectl
  yaml_body = templatefile("${path.module}/cert-manager-templates/cluster-issuer.tftpl", {
    cluster_issuer_name   = var.cert_manager_cluster_issuer_name,
    cluster_issuer_server               = var.cert_manager_cluster_issuer_server,
    dns_zone = var.cert_manager_dns_zone,
    aws_region = var.aws_region,
    hosted_zone_id = var.cert_manager_r53_zone_id,
    role_arn = aws_iam_role.cert_manager_iam_role.arn,
  })

  depends_on = [module.eks_blueprints_addons]
}
