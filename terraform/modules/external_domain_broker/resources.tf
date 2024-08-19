# These resources are for https://github.com/cloud-gov/external-domain-broker

resource "aws_route53_zone" "zone" {
  name    = "external-domains-${var.stack_description}.cloud.gov"
  comment = "Hosts TXT and CNAME records for the external-domain-broker"
}

data "aws_route53_zone" "cloud_gov" {
  name = "cloud.gov"
}

resource "aws_route53_record" "record" {
  name    = aws_route53_zone.zone.name
  zone_id = data.aws_route53_zone.cloud_gov.zone_id
  type    = "NS"
  ttl     = "60"

  records = [
    aws_route53_zone.zone.name_servers[0],
    aws_route53_zone.zone.name_servers[1],
    aws_route53_zone.zone.name_servers[2],
    aws_route53_zone.zone.name_servers[3],
  ]
}

data "aws_canonical_user_id" "current_user" {
  provider = aws.standard
}

resource "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket = "external-domain-broker-cloudfront-logs-${var.stack_description}"
}

resource "aws_s3_bucket_public_access_block" "cloudfront_log_bucket_block_public" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_log_bucket_lifecycle" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id
  rule {
    id     = "log-rule"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }

    # Delete objects after 30 months per M-21-31 guidelines
    # 31 days * 30 months = 930 days
    expiration {
      days = 930
    }
  }
}

resource "aws_s3_bucket_acl" "cloudfront_log_bucket_acl" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current_user.id
    }

    grant {
      permission = "FULL_CONTROL"
      grantee {
        # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html#AccessLogsBucketAndFileOwnership
        # canonical user id of awslogsdelivery
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type = "CanonicalUser"
      }
    }
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_log_bucket_sse_config" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
