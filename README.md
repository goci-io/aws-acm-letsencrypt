# aws-acm-letsencrypt

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

![Terraform Validate](https://github.com/goci-io/aws-acm-letsencrypt/workflows/Terraform%20Validate/badge.svg)

This module requests a new certificate from [letsencrypt](http://letsencrypt.org) and uploads it to AWS ACM. 
The certificate validation is done via Route53 DNS. 

To avoid creating multiple letsencrypt accounts you can use the [letsencrypt-account](https://github.com/goci-io/letsencrypt-account) module.
This is the recommended use of letsencrypt.

### Usage

```hcl
module "acme" {
  source            = "git::https://github.com/goci-io/aws-acm-letsencrypt.git?ref=tags/<latest-version>"
  namespace         = "goci"
  stage             = "staging"
  name              = "api"
  domain            = "api.staging.eu1.goci.io"
  aws_region        = "eu-central-1"

  account_key_state_module = "path-to-remote-state-key.tfstate"
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
| certificate_email | E-Mail address to use for the certificate and contact options. Only required if no existing account_key_pem is provided | `""` |
| account_key_pem | Existing private key for your letsencrypt account | `""` |
| account_key_state_module | Reference to remote state file with `account_key_pem` output | `""` |
| acme_production | Overwrites stage detection for letsencrypt to production directory | `false` |
| enabled | Whether to create resources or not | `true` |
| aws_region | AWS Region to deploy the ACM into. Note that sometimes AWS requires the certificate to be in us-east-1 | - |
| aws_assume_role_arn | AWS Role to assume to create resources | `""` |

### Renewal

Certificates are automatically renewed when the `min_remaining_days` are less than the actual days to the expiry date.
The terraform [ACME resource](https://www.terraform.io/docs/providers/acme/r/certificate.html#certificate-renewal) takes care of it so you must run your pipeline at least once within **40 days**.

### Migration

When migrating or changing the certificate we may have to replace the existing ACM certificate. 
If you deploy multiple terraform modules and other resources are still referencing the old certificate we suggest to do the following:

1. Deploy a new version of this module (with new state)  
2. Replace remote state references to the new version  
3. Destroy the old module and state
