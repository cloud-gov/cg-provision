

output "terraform_provision_access_id" {
  value = module.terraform_provision_user.terraform_provision_access_id
}

output "terraform_provision_access_secret" {
  value     = module.terraform_provision_user.terraform_provision_access_secret
  sensitive = true
}

output "aws_s3_tfstate_bucket" {
  value = module.tfstate_bucket.bucket_name
}
