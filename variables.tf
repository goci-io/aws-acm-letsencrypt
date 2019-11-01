
variable "stage" {
  type        = string
  description = "The stage the resources will be deployed for"
}

variable "name" {
  type        = string
  default     = "api"
  description = "The name for this certificate"
}

variable "namespace" {
  type        = string
  description = "Organization or company namespace prefix"
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `eu1`)"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

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

variable "region" {
  type        = string
  default     = ""
  description = "Custom name for the region. Defaults to aws_region"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the ACM certificate into"
}

variable "aws_assume_role_arn" {
  type        = string
  default     = ""
  description = "The AWS Role ARN to assume to create resources"
}


