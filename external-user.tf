# ACME DNS challenge requires ACCESS_ and SECRET_KEY if hosted zone is in an external AWS Account
# The created IAM user is responsible to manage the dns validation record
# Alternative would be to use a custom AWS_PROFILE but it does not seem to be accepted either

module "iam_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  context    = module.label.context
  attributes = [local.region]
}

data "aws_iam_policy_document" "dns_change" {
  count = var.external_account && var.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = [
      "route53:GetChange",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.validation.zone_id}",
      "arn:aws:route53:::change/*",
    ]
  }
}

resource "aws_iam_user" "dns_user" {
  count = var.external_account && var.enabled ? 1 : 0
  name  = module.iam_label.id
  tags  = module.iam_label.tags
  path  = "/service/"
}

resource "aws_iam_user_policy" "attachment" {
  count  = var.external_account && var.enabled ? 1 : 0
  name   = module.iam_label.id
  user   = join("", aws_iam_user.dns_user.*.name)
  policy = join("", data.aws_iam_policy_document.dns_change.*.json)
}

resource "aws_iam_access_key" "dns_user" {
  depends_on = [null_resource.await_access]
  count      = var.external_account && var.enabled ? 1 : 0
  user       = join("", aws_iam_user.dns_user.*.name)
}

resource "null_resource" "await_access" {
  count = var.external_account && var.enabled ? 1 : 0

  provisioner "local-exec" {
    command = "sleep 30"
  }

  triggers = {
    user = join("", aws_iam_user.dns_user.*.arn)
  }
}
