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

variable "cluster_security_group_additional_rules" {
  description = "The additional rules for the cluster security group"
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
      "values" : ["nano", "micro", "small", "medium", "large", "xlarge"]
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
        "6"
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
      "values" : ["nano", "micro", "small", "medium", "large", "xlarge"]
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
