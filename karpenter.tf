
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.34"

  cluster_name = module.eks.cluster_name

  # Name needs to match role name passed to the EC2NodeClass
  node_iam_role_use_name_prefix   = false
  node_iam_role_name              = var.cluster_name
  create_pod_identity_association = true

  tags = var.tags
}


resource "helm_release" "karpenter_crd" {
  namespace  = "kube-system"
  name       = "karpenter-crd"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter-crd"
  version    = "0.37.7"
  wait       = true

  set {
    name  = "webhook.enabled"
    value = "true"
  }
  set {
    name  = "webhook.serviceName"
    value = "karpenter"
  }
  set {
    name  = "webhook.port"
    value = "8443"
  }
}

resource "helm_release" "karpenter" {
  namespace  = "kube-system"
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.0.9"
  skip_crds  = true
  wait       = true

  values = [
    templatefile("${path.module}/karpenter-templates/karpenter-setup.tftpl", {
      eks_cluster_name     = module.eks.cluster_name,
      eks_cluster_endpoint = module.eks.cluster_endpoint,
      karpenter_queue_name = module.karpenter.queue_name,
      karpenter_replicas   = var.karpenter_replicas
    })
  ]
  depends_on = [helm_release.karpenter_crd]
}

resource "kubectl_manifest" "karpenter_ec2_node_class" {
  provider = kubectl
  yaml_body = templatefile("${path.module}/karpenter-templates/karpenter-ec2-node-class.tftpl", {
    karpenter_ami_family_class = var.karpenter_ami_family_class,
    karpenter_node_role_name   = module.karpenter.node_iam_role_name,
    eks_cluster_name           = module.eks.cluster_name
  })

  depends_on = [ helm_release.karpenter ]
}

resource "kubectl_manifest" "karpenter_node_pool_spot" {
  count    = var.create_spot_karpenter_node_pool_config ? 1 : 0
  provider = kubectl
  yaml_body = templatefile("${path.module}/karpenter-templates/karpenter-node-pool-spot.tftpl", {
    spot_karpenter_node_pool_limits       = jsonencode(var.spot_karpenter_node_pool_limits),
    spot_karpenter_node_pool_requirements = jsonencode(var.spot_karpenter_node_pool_requirements),
    spot_karpenter_node_pool_expire_after = var.spot_karpenter_node_pool_expire_after,
  })

  depends_on = [kubectl_manifest.karpenter_ec2_node_class]
}

resource "kubectl_manifest" "karpenter_node_pool_ondemand" {
  count    = var.create_ondemand_karpenter_node_pool_config ? 1 : 0
  provider = kubectl
  yaml_body = templatefile("${path.module}/karpenter-templates/karpenter-node-pool-ondemand.tftpl", {
    ondemand_karpenter_node_pool_limits       = jsonencode(var.ondemand_karpenter_node_pool_limits),
    ondemand_karpenter_node_pool_requirements = jsonencode(var.ondemand_karpenter_node_pool_requirements),
    ondemand_karpenter_node_pool_expire_after = var.ondemand_karpenter_node_pool_expire_after,
  })

  depends_on = [kubectl_manifest.karpenter_ec2_node_class]
}


