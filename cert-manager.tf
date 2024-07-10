module "cert_manager_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.40.0"

  name        = "cert-manager-route53-policy"
  path        = "/"
  description = "Policy to allow the external-secrets-operator to read SSM parameters."

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": "route53:GetChange",
            "Resource": "arn:aws:route53:::change/*"
            },
            {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/${var.external_dns_hosted_zone_id}"
            },
            {
            "Effect": "Allow",
            "Action": "route53:ListHostedZonesByName",
            "Resource": "*"
            }
        ]
    }
  )

  tags = var.tags
}

module "cert_manager_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.40.0"

  create_role = true
  role_name   = "cert-manager-route53-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cert-manager",
  ]

  role_requires_mfa = false

  custom_role_policy_arns = [

    module.cert_manager_iam_policy.arn
  ]

  tags = var.tags

}
