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

resource "opensearch_roles_mapping" "cf_user_mapping" {
  role_name   = "cf_user"
  description = "CF users with privileges to their own spaces"
  backend_roles = [
    "user",
    aws_am_user.dashboard_proxy_user.arn
  ]
}

resource "opensearch_roles_mapping" "admin_all_access" {
  role_name   = "all_access"
  description = "Administrators with unrestricted access"
  backend_roles = [
    "admin",
  ]
}
