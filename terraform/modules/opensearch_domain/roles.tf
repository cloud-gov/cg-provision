resource "opensearch_role" "cf_user" {
  role_name = "cf_user"

  cluster_permissions = [
    "read",
    "cluster:monitor/nodes/stats",
    "cluster:monitor/task/get"
  ]

  index_permissions {
    index_patterns          = ["logs-app-*"]
    allowed_actions         = ["read"]
    document_level_security = "{\"bool\": {\"should\": [{\"terms\": { \"@cf.space_id\": [$${attr.proxy.spaceids}] }}, {\"terms\": {\"@cf.org_id\": [$${attr.proxy.orgids}]}}]}}"
  }
}

resource "opensearch_role" "cf_org_space_roles" {
  for_each = var.cf_org_spaces
  role_name = "${each.key}-${each.value}"

  cluster_permissions = [
    "read",
    "cluster:monitor/nodes/stats",
    "cluster:monitor/task/get"
  ]

  index_permissions {
    index_patterns          = ["logs-app-*"]
    allowed_actions         = ["read"]
    document_level_security = "{\"bool\": {\"should\": [{\"terms\": { \"@cf.space_id\": [${each.value}] }}, {\"terms\": {\"@cf.org_id\": [${each.key}]}}]}}"
  }
}

resource "opensearch_roles_mapping" "cf_org_space_roles_mapping" {
  for_each = var.cf_org_spaces
  role_name = "${each.key}-${each.value}"
  description = "CF users with privileges to their own spaces"
  backend_roles = [
    "${each.key}-${each.value}"
  ]
}

resource "opensearch_roles_mapping" "cf_user_mapping" {
  role_name   = "cf_user"
  description = "CF users with privileges to their own spaces"
  backend_roles = [
    "user",
    aws_iam_user.dashboard_proxy_user.arn,
    "cloud_controller.write"
  ]
}

resource "opensearch_roles_mapping" "admin_all_access" {
  role_name   = "all_access"
  description = "Mapping AWS IAM roles to ES role"
  users = [
    var.master_user_name,
    var.master_user_arn
  ]
  backend_roles = [
    "admin",
    var.master_user_arn,
  ]
}
