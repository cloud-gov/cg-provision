resource "aws_iam_user" "dashboard_proxy_user" {
  name = "${var.domain_name}-dashboards-proxy"
}
