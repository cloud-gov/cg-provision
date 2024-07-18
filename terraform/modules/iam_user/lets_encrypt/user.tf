data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}

data "template_file" "policy" {
  template = file("${path.module}/policy.json")
  vars = {
    aws_partition = var.aws_partition
    hosted_zone   = data.aws_route53_zone.zone.zone_id
  }
}

resource "aws_iam_user" "iam_user" {
  name = var.username
}

resource "aws_iam_access_key" "iam_access_key_v3" {
  user = aws_iam_user.iam_user.name
}

resource "aws_iam_user_policy" "iam_policy" {
  name   = "${aws_iam_user.iam_user.name}-policy"
  user   = aws_iam_user.iam_user.name
  policy = data.template_file.policy.rendered
}

