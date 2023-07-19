resource "opensearch_index_template" "index_template" {
  name     = test_index
  body     = <<EOF
{
  "index_patterns": ["${each.key}*"],
  "template" : {
    "settings": {
      "plugins.index_state_management.rollover_alias": "${each.key}"
   }
  }
}
EOF
}