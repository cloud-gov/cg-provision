variable "remote_state_bucket" {
}

variable "tooling_stack_name" {
}

variable "repositories" {
  type = set(string)
  default = [
    "bosh-deployment-resource",
    "bosh-io-release-resource",
    "bosh-io-stemcell-resource",
    "cf-cli-resource",
    "cf-resource",
    "cloud-service-broker",
    "concourse-task",
    "cron-resource",
    "csb",
    "email-resource",
    "general-task",
    "git-resource",
    "github-pr-resource",
    "github-release-resource",
    "oci-build-task",
    "pages-dind",
    "pages-dind-v25",
    "pages-nginx-v1",
    "pages-node-v20",
    "pages-postgres-v15",
    "pages-python-v3.11",
    "pages-redis-v7.2",
    "pages-zap",
    "playwright-python",
    "pool-resource",
    "pulledpork",
    "registry-image-resource",
    "s3-resource",
    "s3-simple-resource",
    "semver-resource",
    "slack-notification-resource",
    "time-resource",
    "ubuntu-hardened",
  ]
}

terraform {
  backend "s3" {
  }
}


data "terraform_remote_state" "tooling" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "${var.tooling_stack_name}/terraform.tfstate"
  }
}


resource "aws_ecr_repository" "repository" {
  for_each = var.repositories

  name                 = each.key
  image_tag_mutability = "MUTABLE"
  tags                 = {}
  tags_all             = {}
}
