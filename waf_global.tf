# Define the Global WAF Policy
resource "azurerm_web_application_firewall_policy" "waf_policy_global" {
  name                = "wafpolicyGlobal"
  resource_group_name = azurerm_resource_group.rg.name     # Or use azurerm_resource_group.rg.name if it's the same RG
  location            = azurerm_resource_group.rg.location # Or use azurerm_resource_group.rg.location

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    max_request_body_size_in_kb = 100
    file_upload_limit_in_mb     = 256
  }

  custom_rules {
    name      = "globalAllow"
    priority  = 5
    rule_type = "MatchRule"
    action    = "Allow"
    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      operator     = "Contains"
      match_values = ["globalAllow"]
    }
  }

  custom_rules {
    name      = "globalBlock"
    priority  = 10
    rule_type = "MatchRule"
    action    = "Block"
    match_conditions {
      match_variables {
        variable_name = "RequestUri"
      }
      operator     = "Contains"
      match_values = ["globalBlock"]
    }
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}