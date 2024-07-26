data "aws_availability_zones" "available" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_caller_identity" "current" {}


data "aws_ssm_parameter" "clusters_server_secret" {
  for_each = var.workload_eks_clusters
  name = "/platform/argocd/eks/clusters/server/${each.key}"
}

data "aws_ssm_parameter" "clusters_config_secret" {
  for_each = var.workload_eks_clusters
  name = "/platform/argocd/eks/clusters/config/${each.key}"
}