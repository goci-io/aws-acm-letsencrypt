
data "terraform_remote_state" "acme_account" {
  count   = var.account_key_state_module == "" ? 0 : 1
  backend = "s3"

  config = {
    bucket = var.tf_bucket
    key    = var.account_key_state_module
  }
}

locals {
  remote_state_account_key = join("", data.terraform_remote_state.acme_account.*.outputs.account_key_pem)
  existing_account_key     = local.remote_state_account_key == "" ? var.account_key_pem : local.remote_state_account_key
}
