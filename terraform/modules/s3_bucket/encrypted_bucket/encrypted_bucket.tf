resource "aws_s3_bucket" "encrypted_bucket" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encrypted_bucket_sse_config" {
  bucket = aws_s3_bucket.encrypted_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "encrypted_bucket_versioning" {
  count = var.versioning ? 1 : 0
  bucket = aws_s3_bucket.encrypted_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_acl" "encrypted_bucket_acl" {
  bucket = aws_s3_bucket.encrypted_bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_lifecycle_configuration" "encrypted_bucket_lifecycle" {
  bucket = aws_s3_bucket.encrypted_bucket.id
  rule {
    id = "rule0"
    filter {
      prefix  = ""
    }
    #if expiration_days is 0 then the rule is disabled
    status = var.expiration_days == 0 ? "Disabled" : "Enabled"
    expiration {
      # Hack: Set expiration days to 30 if unset; objects won't actually be expired because the rule will be disabled
      # See https://github.com/terraform-providers/terraform-provider-aws/issues/1402
      days = var.expiration_days == 0 ? 30 : var.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "encrypted_bucket_policy" {
  count = var.include_require_encrypted_put_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.encrypted_bucket.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "DenyUnencryptedPut",
        "Effect": "Deny",
        "Principal": {
            "AWS": "*"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:${var.aws_partition}:s3:::${var.bucket}/*",
        "Condition": {
            "StringNotEquals": {
                "s3:x-amz-server-side-encryption": "AES256"
            }
        }
    }]
}
EOF

}

