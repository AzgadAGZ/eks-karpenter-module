module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller    = true
  aws_load_balancer_controller = {
    chart_version = var.aws_load_balancer_controller_chart_version
  }
  enable_metrics_server                  = true
  enable_cert_manager                    = true
  cert_manager = {
    chart_version    = var.cert_manager_chart_version
  }

  tags = var.tags
}