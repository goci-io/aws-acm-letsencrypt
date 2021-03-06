
locals {
  domain_parts    = split(".", var.domain_name)
  region          = var.region == "" ? var.aws_region : var.region
  hosted_zone     = join(".", slice(local.domain_parts, 1, length(local.domain_parts)))
  account_key_pem = local.existing_account_key == "" ? module.acme_registration.account_key_pem : local.existing_account_key
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  name       = var.name
  attributes = var.attributes
  tags       = merge(var.tags, { Region = local.region })
}

data "aws_route53_zone" "validation" {
  name         = format("%s.", local.hosted_zone)
  private_zone = false
}

module "acme_registration" {
  source            = "git::https://github.com/goci-io/letsencrypt-account.git?ref=tags/0.1.0"
  enabled           = local.existing_account_key == "" && var.enabled
  certificate_email = var.certificate_email
}

resource "acme_certificate" "certificate" {
  count                     = var.enabled ? 1 : 0
  depends_on                = [null_resource.await_access]
  account_key_pem           = local.account_key_pem
  common_name               = var.domain_name
  subject_alternative_names = var.alternative_names
  min_days_remaining        = 40

  dns_challenge {
    provider = "route53"

    config = {
      AWS_REGION            = var.aws_region
      AWS_HOSTED_ZONE_ID    = data.aws_route53_zone.validation.zone_id
      AWS_ACCESS_KEY_ID     = var.external_account ? join("", aws_iam_access_key.dns_user.*.id) : ""
      AWS_SECRET_ACCESS_KEY = var.external_account ? join("", aws_iam_access_key.dns_user.*.secret) : ""
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "acme" {
  count             = var.enabled ? 1 : 0
  tags              = module.label.tags
  private_key       = join("", acme_certificate.certificate.*.private_key_pem)
  certificate_body  = join("", acme_certificate.certificate.*.certificate_pem)
  certificate_chain = join("", acme_certificate.certificate.*.issuer_pem)

  lifecycle {
    # When migrating the certificate we suggest the following:
    # Deploy a new one, replace references and then destroy the old module
    create_before_destroy = true
  }
}
