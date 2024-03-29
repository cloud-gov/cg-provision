# Most stacks do not pass credentials this way. For an explanation of why
# access and state are managed differently in the cloudfront stack compared
# to the other stacks, see README.md, "DNS and CloudFront Stacks" in the root
# of the repo.
variable "aws_access_key" {
}

variable "aws_secret_key" {
  sensitive = true
}

variable "aws_region" {
}

terraform {
  backend "s3" {
  }
}

provider "aws" {
  access_key        = var.aws_access_key
  secret_key        = var.aws_secret_key
  region            = var.aws_region
  use_fips_endpoint = true

  endpoints {
    # see https://github.com/hashicorp/terraform-provider-aws/issues/23619#issuecomment-1169369626
    # and https://aws.amazon.com/compliance/fips/#FIPS_Endpoints_by_Service
    cloudfront = "https://cloudfront-fips.amazonaws.com"
  }

  default_tags {
    tags = {
      deployment = "cloudfront-${var.stack_description}"
      stack      = "${var.stack_description}"
    }
  }
}

data "terraform_remote_state" "govcloud" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    region = var.remote_state_region
    key    = "${var.stack_description}/terraform.tfstate"
  }
}

# One ACL for all distributions in the environment.
resource "aws_wafv2_web_acl" "commercial_acl" {
  name        = "${var.stack_description}-commercial-acl"
  description = "ACL for use with CloudFront and Shield Advanced."
  scope       = "CLOUDFRONT"

  default_action {
    # no rules needed; they'll be added by Shield Advanced.
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.stack_description}-commercial-acl-metric"
    sampled_requests_enabled   = true
  }
}

module "star_admin" {
  source = "../../modules/cloudfront"
  origin = {
    lb_dns_name   = data.terraform_remote_state.govcloud.outputs.cf_lb_dns_name
    lb_http_port  = 80  # modules/cloudfoundry/elb_main.tf "aws_lb" "cf"
    lb_https_port = 443 # modules/cloudfoundry/elb_main.tf "aws_lb" "cf"
  }
  acl_arn = aws_wafv2_web_acl.commercial_acl.arn
}
