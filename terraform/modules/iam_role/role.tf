resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  path               = var.role_path
  assume_role_policy = var.iam_assume_role_policy
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = var.role_name
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy" "iam_policy" {
  count  = var.iam_policy != "" ? 1 : 0
  name   = var.role_name
  policy = var.iam_policy
  role   = aws_iam_role.iam_role.name
}

