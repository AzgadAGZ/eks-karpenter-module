module "eso_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.40.0"

  name        = "external-secrets-operator-ssm-policy"
  path        = "/"
  description = "Policy to allow the external-secrets-operator to read SSM parameters."

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "ssm:DescribeParameters",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
        }
      ]
    }
  )

  tags = var.tags
}

module "eso_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.40.0"

  create_role = true
  role_name   = "external-secrets-operator-ssm-role"

  provider_url = module.eks.oidc_provider

  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]

  oidc_fully_qualified_subjects = [
    "system:serviceaccount:external-secrets:${var.eso_service_account_name}"
  ]


  role_policy_arns = [
    module.eso_iam_policy.arn
  ]

  tags = var.tags

}


resource "kubernetes_config_map" "init_data" {
  metadata {
    name = "external-secrets-init-data"
  }

  data = {
    eso-role-arn             = module.eso_iam_role.iam_role_arn
    eso-service-account-name = var.eso_service_account_name
    eso-cluster-store-name   = var.eso_cluster_store_name
  }
}


resource "aws_ssm_parameter" "eso_cluster_store_name" {
  name  = "/platform/eso/cluster-store-name"
  type  = "String"
  value = var.eso_cluster_store_name
}
