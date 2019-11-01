
output "certificate_url" {
  value = join("", acme_certificate.certificate.*.id)
}

output "private_key" {
  value     = join("", tls_private_key.private_key.*.private_key_pem)
  sensitive = true
}

output "certificate_body" {
  value = join("", acme_certificate.certificate.*.certificate_pem)
}

output "certificate_chain" {
  value = join("", acme_certificate.certificate.*.issuer_pem)
}

output "certificate_arn" {
  value = join("", aws_acm_certificate.acme.*.arn)
}
