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
