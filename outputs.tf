
output "certificate_url" {
  value = join("", acme_certificate.certificate.*.id)
}

output "certificate_key" {
  value     = join("", acme_certificate.certificate.*.private_key_pem)
  sensitive = true
}

output "certificate_body" {
  value = join("", acme_certificate.certificate.*.certificate_pem)
}

output "certificate_ca_cert" {
  value = join("", acme_certificate.certificate.*.issuer_pem)
}

output "certificate_ca_key" {
  value     = local.account_key_pem
  sensitive = true
}

output "certificate_arn" {
  value = join("", aws_acm_certificate.acme.*.arn)
}
