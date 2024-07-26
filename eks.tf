module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.subnet_ids
  cluster_name                             = var.cluster_name
  access_entries                           = var.access_entries
  cluster_version                          = var.cluster_version
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions
  cluster_endpoint_public_access           = false
  authentication_mode                      = var.authentication_mode
  cloudwatch_log_group_retention_in_days   = var.cloudwatch_log_group_retention_in_days
  cluster_addons = {
    coredns = {
      most_recent = var.cluster_addons_auto_update
      configuration_values = jsonencode({
        tolerations = [
          # Allow CoreDNS to run on the same nodes as the Karpenter controller
          # for use during cluster creation when Karpenter nodes do not yet exist
          {
            key    = "karpenter.sh/controller"
            value  = "true"
            effect = "NoSchedule"
          }
        ]
      })
    }
    eks-pod-identity-agent = {
      most_recent = var.cluster_addons_auto_update
    }
    kube-proxy = {
      most_recent = var.cluster_addons_auto_update
    }
    vpc-cni = {
      most_recent = var.cluster_addons_auto_update
    }
  }

  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  enable_efa_support                      = false
  eks_managed_node_groups = {
    karpenter = {
      ami_type       = var.managed_nodes_ami_type
      name           = "eks-control-plane"
      instance_types = var.managed_nodes_instance_types

      min_size     = var.managed_nodes_min_size
      max_size     = var.managed_nodes_max_size
      desired_size = var.managed_nodes_desired_size

      create_launch_template = true                                 # false will use the default launch template
      launch_template_os     = var.managed_nodes_launch_template_os # amazonlinux2eks or bottlerocket

      labels = {
        # Used to ensure Karpenter runs on nodes that it does not manage
        "karpenter.sh/controller" = "true"
      }

      taints = var.managed_nodes_taints
    }
  }

  tags = merge(var.tags,
    {
      "karpenter.sh/discovery" = "${var.cluster_name}"
  })
}


resource "aws_ssm_parameter" "eks_cluster_endpoint" {
  name  = "/platform/eks/endpoint"
  type  = "SecureString"
  value = module.eks.cluster_endpoint
}

resource "aws_ssm_parameter" "eks_cluster_ca" {
  name  = "/platform/eks/ca"
  type  = "SecureString"
  value = module.eks.cluster_certificate_authority_data
}

resource "kubernetes_secret" "eks_clusters" {
  for_each = var.workload_eks_clusters

  metadata {
    name = "${each.key}-cluster"
    namespace = "argocd"

    labels = {
      "argocd.argoproj.io/secret-type": "cluster"
    }

    annotations = {
      "managed-by": "argocd.argoproj.io"
    }
  }

  

  data = {
    "name" = each.key
    "config" = data.aws_ssm_parameter.clusters_config_secret[each.key].value
    "server" = data.aws_ssm_parameter.clusters_server_secret[each.key].value
  }

  type = "Opaque"
}

