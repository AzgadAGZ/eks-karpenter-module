module "cert_manager_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.40.0"

  name        = "cert-manager-route53-policy"
  path        = "/"
  description = "Policy to allow the external-secrets-operator to read SSM parameters."

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "route53:GetChange",
          "Resource" : "arn:aws:route53:::change/*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : "arn:aws:route53:::hostedzone/${var.external_dns_hosted_zone_id}"
        },
        {
          "Effect" : "Allow",
          "Action" : "route53:ListHostedZonesByName",
          "Resource" : "*"
        }
      ]
    }
  )

  tags = var.tags
}


resource "aws_iam_role" "cert_manager_iam_role" {
  name = "cert-manager-route53-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "*"
        }
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cert-manager-*"
          }
        }
      },
    ]
  })

  tags = var.tags
}


resource "aws_iam_policy_attachment" "cert_manager_role_attachment" {
  name = "cert_manager_role_attachment"
  roles = [
    aws_iam_role.cert_manager_iam_role.name
  ]
  policy_arn = module.cert_manager_iam_policy.arn
}

