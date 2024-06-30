# gitops-eks-karpenter-module

# Post Activities if necessary
https://argocd-autopilot.readthedocs.io/en/stable/Getting-Started/


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.55.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.14.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.55.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | >= 5.55.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.14.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 2.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.14.0 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> 20.14 |

## Resources

| Name | Type |
|------|------|
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.karpenter_ec2_node_class](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_pool_ondemand](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_pool_spot](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecrpublic_authorization_token) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | List of access entries | `map` | `{}` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | The authentication mode for the EKS cluster | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"us-east-2"` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | The retention period of the CloudWatch log group | `number` | `7` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether or not to enable public access to EKS API | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_security_group_additional_rules"></a> [cluster\_security\_group\_additional\_rules](#input\_cluster\_security\_group\_additional\_rules) | The additional security group rules for the EKS cluster | `map` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The Kubernetes version for the EKS cluster | `string` | n/a | yes |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | The list of subnet IDs for the control plane | `list(string)` | n/a | yes |
| <a name="input_create_ondemand_karpenter_node_pool_config"></a> [create\_ondemand\_karpenter\_node\_pool\_config](#input\_create\_ondemand\_karpenter\_node\_pool\_config) | Whether to create an on-demand Karpenter node pool | `bool` | `true` | no |
| <a name="input_create_spot_karpenter_node_pool_config"></a> [create\_spot\_karpenter\_node\_pool\_config](#input\_create\_spot\_karpenter\_node\_pool\_config) | Whether to create an spot Karpenter node pool | `bool` | `true` | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Map of EKS managed node groups | `map` | <pre>{<br>  "ami_type": "BOTTLEROCKET_ARM_64",<br>  "create_launch_template": true,<br>  "desired_size": 2,<br>  "instance_types": [<br>    "t4g.large"<br>  ],<br>  "labels": {<br>    "karpenter.sh/controller": "true"<br>  },<br>  "launch_template_os": "bottlerocket",<br>  "max_size": 2,<br>  "min_size": 0,<br>  "name": "eks-control-plane",<br>  "taints": {<br>    "karpenter": {<br>      "effect": "NO_SCHEDULE",<br>      "key": "karpenter.sh/controller",<br>      "value": "true"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_enable_cluster_creator_admin_permissions"></a> [enable\_cluster\_creator\_admin\_permissions](#input\_enable\_cluster\_creator\_admin\_permissions) | Whether to enable admin permissions for the cluster creator | `bool` | `true` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Whether to enable IRSA for the EKS cluster | `bool` | `true` | no |
| <a name="input_karpenter_ami_family_class"></a> [karpenter\_ami\_family\_class](#input\_karpenter\_ami\_family\_class) | The AMI family class for Karpenter | `string` | `"Bottlerocket"` | no |
| <a name="input_karpenter_replicas"></a> [karpenter\_replicas](#input\_karpenter\_replicas) | The number of Karpenter replicas | `number` | `1` | no |
| <a name="input_ondemand_karpenter_node_pool_expire_after"></a> [ondemand\_karpenter\_node\_pool\_expire\_after](#input\_ondemand\_karpenter\_node\_pool\_expire\_after) | The default Karpenter On Demand node pool expire time duration | `string` | `"168h0m0s"` | no |
| <a name="input_ondemand_karpenter_node_pool_limits"></a> [ondemand\_karpenter\_node\_pool\_limits](#input\_ondemand\_karpenter\_node\_pool\_limits) | The default Karpenter On Demand node pool configuration | `map` | <pre>{<br>  "cpu": "20",<br>  "memory": "200Gi"<br>}</pre> | no |
| <a name="input_ondemand_karpenter_node_pool_requirements"></a> [ondemand\_karpenter\_node\_pool\_requirements](#input\_ondemand\_karpenter\_node\_pool\_requirements) | The default Karpenter On Demand node pool configuration | `list` | <pre>[<br>  {<br>    "key": "capacity-spread",<br>    "operator": "In",<br>    "values": [<br>      "1"<br>    ]<br>  },<br>  {<br>    "key": "kubernetes.io/arch",<br>    "operator": "In",<br>    "values": [<br>      "amd64"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.sh/capacity-type",<br>    "operator": "In",<br>    "values": [<br>      "on-demand"<br>    ]<br>  },<br>  {<br>    "key": "kubernetes.io/os",<br>    "operator": "In",<br>    "values": [<br>      "linux"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-category",<br>    "operator": "In",<br>    "values": [<br>      "c",<br>      "m",<br>      "r"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-cpu",<br>    "operator": "In",<br>    "values": [<br>      "1",<br>      "2",<br>      "4"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-memory",<br>    "operator": "IN",<br>    "values": [<br>      "2Gi",<br>      "4Gi",<br>      "8Gi",<br>      "16Gi"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-generation",<br>    "operator": "Gt",<br>    "values": [<br>      "2"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_spot_karpenter_node_pool_expire_after"></a> [spot\_karpenter\_node\_pool\_expire\_after](#input\_spot\_karpenter\_node\_pool\_expire\_after) | The default Karpenter Spot node pool expire time duration | `string` | `"168h0m0s"` | no |
| <a name="input_spot_karpenter_node_pool_limits"></a> [spot\_karpenter\_node\_pool\_limits](#input\_spot\_karpenter\_node\_pool\_limits) | The default Karpenter Spot node pool configuration | `map` | <pre>{<br>  "cpu": "20",<br>  "memory": "200Gi"<br>}</pre> | no |
| <a name="input_spot_karpenter_node_pool_requirements"></a> [spot\_karpenter\_node\_pool\_requirements](#input\_spot\_karpenter\_node\_pool\_requirements) | The default Karpenter Spot node pool configuration | `list` | <pre>[<br>  {<br>    "key": "capacity-spread",<br>    "operator": "In",<br>    "values": [<br>      "2",<br>      "3",<br>      "4",<br>      "5",<br>      "6"<br>    ]<br>  },<br>  {<br>    "key": "kubernetes.io/arch",<br>    "operator": "In",<br>    "values": [<br>      "amd64"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.sh/capacity-type",<br>    "operator": "In",<br>    "values": [<br>      "spot",<br>      "on-demand"<br>    ]<br>  },<br>  {<br>    "key": "kubernetes.io/os",<br>    "operator": "In",<br>    "values": [<br>      "linux"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-category",<br>    "operator": "In",<br>    "values": [<br>      "c",<br>      "m",<br>      "r"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-cpu",<br>    "operator": "In",<br>    "values": [<br>      "1",<br>      "2",<br>      "4"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-memory",<br>    "operator": "IN",<br>    "values": [<br>      "2Gi",<br>      "4Gi",<br>      "8Gi",<br>      "16Gi"<br>    ]<br>  },<br>  {<br>    "key": "karpenter.k8s.aws/instance-generation",<br>    "operator": "Gt",<br>    "values": [<br>      "2"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_entries"></a> [access\_entries](#output\_access\_entries) | Map of access entries created and their attributes |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_cluster_addons"></a> [cluster\_addons](#output\_cluster\_addons) | Map of attribute maps for all EKS cluster addons enabled |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | IAM role name of the EKS cluster |
| <a name="output_cluster_iam_role_unique_id"></a> [cluster\_iam\_role\_unique\_id](#output\_cluster\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts |
| <a name="output_cluster_identity_providers"></a> [cluster\_identity\_providers](#output\_cluster\_identity\_providers) | Map of attribute maps for all EKS identity providers enabled |
| <a name="output_cluster_ip_family"></a> [cluster\_ip\_family](#output\_cluster\_ip\_family) | The IP family used by the cluster (e.g. `ipv4` or `ipv6`) |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_platform_version"></a> [cluster\_platform\_version](#output\_cluster\_platform\_version) | Platform version for the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_cluster_security_group_arn"></a> [cluster\_security\_group\_arn](#output\_cluster\_security\_group\_arn) | Amazon Resource Name (ARN) of the cluster security group |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | ID of the cluster security group |
| <a name="output_cluster_service_cidr"></a> [cluster\_service\_cidr](#output\_cluster\_service\_cidr) | The CIDR block where Kubernetes pod and service IP addresses are assigned from |
| <a name="output_cluster_status"></a> [cluster\_status](#output\_cluster\_status) | Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED` |
| <a name="output_cluster_tls_certificate_sha1_fingerprint"></a> [cluster\_tls\_certificate\_sha1\_fingerprint](#output\_cluster\_tls\_certificate\_sha1\_fingerprint) | The SHA1 fingerprint of the public key of the cluster's certificate |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
| <a name="output_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#output\_eks\_managed\_node\_groups) | Map of attribute maps for all EKS managed node groups created |
| <a name="output_eks_managed_node_groups_autoscaling_group_names"></a> [eks\_managed\_node\_groups\_autoscaling\_group\_names](#output\_eks\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by EKS managed node groups |
| <a name="output_fargate_profiles"></a> [fargate\_profiles](#output\_fargate\_profiles) | Map of attribute maps for all EKS Fargate Profiles created |
| <a name="output_karpenter_event_rules"></a> [karpenter\_event\_rules](#output\_karpenter\_event\_rules) | Map of the event rules created and their attributes |
| <a name="output_karpenter_iam_role_arn"></a> [karpenter\_iam\_role\_arn](#output\_karpenter\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the controller IAM role |
| <a name="output_karpenter_iam_role_name"></a> [karpenter\_iam\_role\_name](#output\_karpenter\_iam\_role\_name) | The name of the controller IAM role |
| <a name="output_karpenter_iam_role_unique_id"></a> [karpenter\_iam\_role\_unique\_id](#output\_karpenter\_iam\_role\_unique\_id) | Stable and unique string identifying the controller IAM role |
| <a name="output_karpenter_instance_profile_arn"></a> [karpenter\_instance\_profile\_arn](#output\_karpenter\_instance\_profile\_arn) | ARN assigned by AWS to the instance profile |
| <a name="output_karpenter_instance_profile_id"></a> [karpenter\_instance\_profile\_id](#output\_karpenter\_instance\_profile\_id) | Instance profile's ID |
| <a name="output_karpenter_instance_profile_name"></a> [karpenter\_instance\_profile\_name](#output\_karpenter\_instance\_profile\_name) | Name of the instance profile |
| <a name="output_karpenter_instance_profile_unique"></a> [karpenter\_instance\_profile\_unique](#output\_karpenter\_instance\_profile\_unique) | Stable and unique string identifying the IAM instance profile |
| <a name="output_karpenter_node_iam_role_arn"></a> [karpenter\_node\_iam\_role\_arn](#output\_karpenter\_node\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role |
| <a name="output_karpenter_node_iam_role_name"></a> [karpenter\_node\_iam\_role\_name](#output\_karpenter\_node\_iam\_role\_name) | The name of the IAM role |
| <a name="output_karpenter_node_iam_role_unique_id"></a> [karpenter\_node\_iam\_role\_unique\_id](#output\_karpenter\_node\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_karpenter_queue_arn"></a> [karpenter\_queue\_arn](#output\_karpenter\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_karpenter_queue_name"></a> [karpenter\_queue\_name](#output\_karpenter\_queue\_name) | The name of the created Amazon SQS queue |
| <a name="output_karpenter_queue_url"></a> [karpenter\_queue\_url](#output\_karpenter\_queue\_url) | The URL for the created Amazon SQS queue |
| <a name="output_node_security_group_arn"></a> [node\_security\_group\_arn](#output\_node\_security\_group\_arn) | Amazon Resource Name (ARN) of the node shared security group |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | ID of the node shared security group |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | The OpenID Connect identity provider (issuer URL without leading `https://`) |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | The ARN of the OIDC Provider if `enable_irsa = true` |
| <a name="output_self_managed_node_groups"></a> [self\_managed\_node\_groups](#output\_self\_managed\_node\_groups) | Map of attribute maps for all self managed node groups created |
| <a name="output_self_managed_node_groups_autoscaling_group_names"></a> [self\_managed\_node\_groups\_autoscaling\_group\_names](#output\_self\_managed\_node\_groups\_autoscaling\_group\_names) | List of the autoscaling group names created by self-managed node groups |
| <a name="output_token"></a> [token](#output\_token) | n/a |
<!-- END_TF_DOCS -->