
terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 6.0.0"
    }
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "1.0.0"
    }
  }
}
