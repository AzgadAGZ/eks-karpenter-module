variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version for the EKS cluster"
}

variable "enable_cluster_creator_admin_permissions" {
  type        = bool
  description = "Whether to enable admin permissions for the cluster creator"
  default     = true
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Whether or not to enable public access to EKS API"
  default     = false
}


variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs"
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs for the control plane"
}

variable "managed_nodes_ami_type" {
  type        = string
  description = "The AMI type for the managed nodes"
  default     = "BOTTLEROCKET_ARM_64"
}

variable "managed_nodes_instance_types" {
  type        = list(string)
  description = "The instance types for the managed nodes"
  default     = ["t4g.large"]
}

variable "managed_nodes_min_size" {
  type        = number
  description = "The minimum size for the managed nodes"
  default     = 1
}

variable "managed_nodes_max_size" {
  type        = number
  description = "The maximum size for the managed nodes"
  default     = 2
}

variable "managed_nodes_desired_size" {
  type        = number
  description = "The desired size for the managed nodes"
  default     = 1
}

variable "managed_nodes_launch_template_os" {
  type        = string
  description = "The OS for the managed nodes launch template"
  default     = "bottlerocket"
}

variable "managed_nodes_taints" {
  description = "The taints for the managed nodes"
  default = {
    # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
    # The pods that do not tolerate this taint should run on nodes created by Karpenter
    karpenter = {
      key    = "karpenter.sh/controller"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }
}

variable "authentication_mode" {
  type        = string
  description = "The authentication mode for the EKS cluster"
  default     = "API_AND_CONFIG_MAP"
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "The retention period of the CloudWatch log group"
  default     = 7
}

variable "enable_irsa" {
  type        = bool
  description = "Whether to enable IRSA for the EKS cluster"
  default     = true
}

variable "access_entries" {
  description = "List of access entries"
  default     = {}
  type        = any
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-2"
}

variable "tags" {
  type        = map(string)
  description = "The tags for the resources"
  default     = {}
}

variable "cluster_addons_auto_update" {
  type        = bool
  description = "Whether to enable auto-update for the cluster addons"
  default     = true
}

variable "cluster_additional_security_group_ids" {
  type        = list(string)
  description = "The additional rules for the cluster security group"
  default     = []
}

variable "cluster_security_group_additional_rules" {
  type        = any
  description = "The additional rules for the cluster security group"
  default     = {}

}

variable "node_security_group_additional_rules" {
  type        = any
  description = "The additional rules for the node security group"
  default     = {}
}

variable "karpenter_replicas" {
  description = "The number of Karpenter replicas"
  default     = 1
}

variable "karpenter_ami_family_class" {
  description = "The AMI family class for Karpenter"
  default     = "Bottlerocket"
  type        = string
}

variable "create_ondemand_karpenter_node_pool_config" {
  description = "Whether to create an on-demand Karpenter node pool"
  default     = true
  type        = bool
}

variable "ondemand_karpenter_node_pool_requirements" {
  description = "The default Karpenter On Demand node pool configuration"
  default = [
    {
      "key" : "capacity-spread",
      "operator" : "In",
      "values" : [
        "1"
      ]
    },
    {
      "key" : "kubernetes.io/arch",
      "operator" : "In",
      "values" : [
        "amd64"
      ]
    },
    {
      "key" : "karpenter.sh/capacity-type",
      "operator" : "In",
      "values" : [
        "on-demand"
      ]
    },
    {
      "key" : "kubernetes.io/os",
      "operator" : "In",
      "values" : [
        "linux"
      ]
    },
    {
      "key" : "karpenter.k8s.aws/instance-category",
      "operator" : "In",
      "values" : [
        "c",
        "m",
        "r",
        "t"
      ]
    },
    {
      "key" : "karpenter.k8s.aws/instance-size",
      "operator" : "In"
      "values" : ["medium", "large", "xlarge"]
    },
    {
      "key" : "karpenter.k8s.aws/instance-generation",
      "operator" : "Gt",
      "values" : [
        "2"
      ]
    }
  ]
}

variable "ondemand_karpenter_node_pool_limits" {
  description = "The default Karpenter On Demand node pool configuration"
  default = {
    cpu    = "20",
    memory = "200Gi"
  }
}

variable "ondemand_karpenter_node_pool_expire_after" {
  description = "The default Karpenter On Demand node pool expire time duration"
  default     = "168h0m0s"
  type        = string
}

variable "create_spot_karpenter_node_pool_config" {
  description = "Whether to create an spot Karpenter node pool"
  default     = true
  type        = bool
}

variable "spot_karpenter_node_pool_requirements" {
  description = "The default Karpenter Spot node pool configuration"
  default = [
    {
      "key" : "capacity-spread",
      "operator" : "In",
      "values" : [
        "2",
        "3",
        "4",
        "5",
      ]
    },
    {
      "key" : "kubernetes.io/arch",
      "operator" : "In",
      "values" : [
        "amd64"
      ]
    },
    {
      "key" : "karpenter.sh/capacity-type",
      "operator" : "In",
      "values" : [
        "spot",
        "on-demand"
      ]
    },
    {
      "key" : "kubernetes.io/os",
      "operator" : "In",
      "values" : [
        "linux"
      ]
    },
    {
      "key" : "karpenter.k8s.aws/instance-category",
      "operator" : "In",
      "values" : [
        "c",
        "m",
        "r",
        "t"
      ]
    },
    {
      "key" : "karpenter.k8s.aws/instance-size",
      "operator" : "In"
      "values" : ["medium", "large", "xlarge"]
    },
    {
      "key" : "karpenter.k8s.aws/instance-generation",
      "operator" : "Gt",
      "values" : [
        "2"
      ]
    }
  ]
}

variable "spot_karpenter_node_pool_limits" {
  description = "The default Karpenter Spot node pool configuration"
  default = {
    cpu    = "20",
    memory = "200Gi"
  }
}

variable "spot_karpenter_node_pool_expire_after" {
  description = "The default Karpenter Spot node pool expire time duration"
  default     = "168h0m0s"
  type        = string
}

variable "cert_manager_chart_version" {
  description = "The version of the cert-manager Helm chart"
  default     = "1.18.0"
  type        = string
}

variable "aws_load_balancer_controller_chart_version" {
  description = "The version of the AWS Load Balancer Controller Helm chart"
  default     = "v1.13.2"
  type        = string
}


variable "external_dns_chart_version" {
  description = "The version of the External DNS Helm chart"
  default     = "v1.16.1"
  type        = string
}

variable "external_dns_hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "external_dns_txt_prefix" {
  description = "The TXT prefix for the External DNS"
  type        = string
}

variable "external_dns_txt_owner_id" {
  description = "The TXT owner ID for the External DNS"
  type        = string
}

variable "external_dns_domain_filter" {
  description = "The domain filter for the External DNS"
  type        = string
}

variable "eso_service_account_name" {
  default     = "external-secrets-operator-service-account"
  description = "The name of the external-secrets-operator service account"
  type        = string
}

variable "eso_cluster_store_name" {
  default     = "external-secrets-operator-cluster-store"
  description = "The name of the cluster store"
  type        = string
}

variable "enable_external_dns" {
  description = "Whether to enable External DNS"
  default     = true
  type        = bool
}

variable "enable_aws_load_balancer_controller" {
  description = "Whether to enable the AWS Load Balancer Controller"
  default     = true
  type        = bool
}

variable "enable_metrics_server" {
  description = "Whether to enable the Metrics Server"
  default     = true
  type        = bool
}

variable "enable_cert_manager" {
  description = "Whether to enable Cert Manager"
  default     = true
  type        = bool
}

variable "enable_external_secrets" {
  description = "Whether to enable External Secrets"
  default     = true
  type        = bool
}

variable "metrics_server_chart_version" {
  description = "The version of the Metrics Server Helm chart"
  default     = "3.12.2"
  type        = string
}


variable "cert_manager_cluster_issuer_name" {
  description = "The name of the Cluster Issuer"
  type        = string
}

variable "cert_manager_cluster_issuer_server" {
  description = "The server of the Cluster Issuer"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "cert_manager_dns_zone" {
  description = "The DNS zone for the cert-manager"
  type        = string
}

variable "cert_manager_r53_zone_id" {
  description = "The Route 53 zone ID for the cert-manager"
  type        = string
}


variable "workload_eks_clusters" {
  description = "The list of EKS clusters"
  type        = list(string)
  default     = []
}

variable "enable_aws_efs_csi_driver" {
  description = "Whether to enable the AWS EFS CSI driver"
  default     = true
  type        = bool
}

variable "aws_efs_csi_driver_chart_version" {
  description = "The version of the AWS EFS CSI driver Helm chart"
  default     = "v2.1.8"
  type        = string
}

