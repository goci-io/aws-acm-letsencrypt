
variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create resources or not"
}

variable "certificate_email" {
  type        = string
  description = "E-Mail to use for the certificate and contact options for the issuer"
}

variable "domain_name" {
  type        = string
  description = "The domain name to include in the certificate"
}

variable "alternative_names" {
  type        = list(string)
  default     = []
  description = "List of subject alternative names for the certificate"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the ACM certificate into"
}

