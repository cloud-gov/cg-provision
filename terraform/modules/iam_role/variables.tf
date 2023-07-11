variable "role_name" {
}

variable "role_path" {
  default = "/bosh-passed/"
}

variable "iam_policy" {
  default = ""
}

variable "iam_assume_role_policy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "opensearchservice.amazonaws.com"
      },
      "Action": "sts:AssumeRole"}
    }
  ]
}
EOF

}

