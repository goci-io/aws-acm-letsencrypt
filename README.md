# aws-acm-letsencrypt

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module requests a new certificate from [letsencrypt](http://letsencrypt.org) and uploads it to AWS ACM. 
The certificate validation is done via Route53 DNS.


### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| domain_name | The domain name to include in the certificate | - |
| alternative_names | Subject alternative domain names | `[]` |
| certificate_email | E-Mail address to use for the certificate and contact options | - |
| enabled | Whether to create resources or not | `true` |
| aws_region | AWS Region to deploy the ACM into. Note that sometimes AWS requires the certificate to be in us-east-1 | - |
