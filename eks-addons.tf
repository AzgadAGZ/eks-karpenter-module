module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    chart_version = var.aws_load_balancer_controller_chart_version
  }
  enable_metrics_server = true
  enable_cert_manager   = true
  cert_manager = {
    chart_version = var.cert_manager_chart_version
  }

  enable_external_dns = true
  external_dns = {
    name          = "external-dns"
    chart_version = var.external_dns_chart_version
    repository    = "https://kubernetes-sigs.github.io/external-dns/"
    namespace     = "external-dns"

    set = [
      {
        name = "extraArgs[0]"
        value = "--aws-prefer-cname"
      },
      {
        name = "extraArgs[1]"
        value = "--txt-prefix=${var.external_dns_txt_prefix}"
      },
      {
        name = "extraArgs[2]"
        value = "--txt-owner-id=${var.external_dns_txt_owner_id}"
      }
    ]
  }

  external_dns_route53_zone_arns = ["arn:aws:route53:::hostedzone/${var.external_dns_hosted_zone_id}"]

  tags = var.tags
}