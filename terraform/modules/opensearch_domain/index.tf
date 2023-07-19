resource "opensearch_index_template" "index_template" {
  name     = "test_index"
  body     = <<EOF
{
  "template" : {
    "settings": {
      "plugins.index_state_management.rollover_alias": "test"
   }
  }
}
EOF
}