# aws-acm-letsencrypt

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module requests a new certificate from [letsencrypt](http://letsencrypt.org) and uploads it to AWS ACM. 
The certificate validation is done via Route53 DNS.

### Usage

```hcl
module "acme" {
  source            = "git::https://github.com/goci-io/aws-acm-letsencrypt.git?ref=tags/<latest-version>"
  namespace         = "goci"
  stage             = "staging"
  name              = "api"
  domain            = "api.staging.eu1.goci.io"
  certificate_email = "certs<at>goci.io"
  aws_region        = "eu-central-1"
}
```

### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| namespace | Company or organiaztion prefix | - |
| stage | Stage the certificate is used for (relates to letsencrypt directory stage) | - |
| region | Custom name for the region | `$aws_region` |
| attributes | Additional attributes (e.g. `eu1`) | `[]` |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `{}`
| domain_name | The domain name to include in the certificate | - |
| alternative_names | Subject alternative domain names | `[]` |
| certificate_email | E-Mail address to use for the certificate and contact options | - |
| enabled | Whether to create resources or not | `true` |
| aws_region | AWS Region to deploy the ACM into. Note that sometimes AWS requires the certificate to be in us-east-1 | - |
