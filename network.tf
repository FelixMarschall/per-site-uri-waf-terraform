# 1. Create an Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-waf-policy-demo"
  location = "westeurope"
}

# 2. Set up a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-appgateway"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3. Create a Subnet for the Application Gateway
# Application Gateway requires a dedicated subnet
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "subnet-appgateway"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"] # Ensure this subnet is large enough for the App Gateway
}

# 4. Create a Public IP address for the Application Gateway
resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "pip-appgateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard" # Standard SKU is required for WAF v2
}

# 5. Deploy an Azure Application Gateway
# This example sets up a basic Application Gateway with a single HTTP listener
# and associates the WAF policy with that listener.
resource "azurerm_application_gateway" "app_gateway" {
  name                = "appgw-waf-demo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # waf_configuration {
  #   enabled = true
  #   firewall_mode = "Prevention" # Can be "Detection" or "Prevention"
  #   rule_set_type = "OWASP"
  #   rule_set_version = "3.2" # Use the same version as in the WAF policy
  # }
  # OR global WAF policy association
  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy_global.id

  sku {
    name     = "WAF_v2" # WAF v2 SKU is required for WAF policies
    tier     = "WAF_v2"
    capacity = 1 # Minimum capacity for WAF_v2
  }

  # Frontend IP Configuration
  frontend_ip_configuration {
    name                 = "appGwFrontendIP"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  # Frontend Port
  frontend_port {
    name = "http-port"
    port = 80
  }

  # Backend Address Pool (example: a dummy backend, replace with your actual backend)
  backend_address_pool {
    name = "appGwBackendPool"
    # You would typically add IP addresses or FQDNs of your backend servers here
    # ip_addresses = ["10.0.2.4", "10.0.2.5"]
  }

  # Backend HTTP Settings
  backend_http_settings {
    name                  = "appGwBackendHttpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  # HTTP Listener - This is where the WAF policy is associated
  http_listener {
    name                           = "appGwHttpListener"
    frontend_ip_configuration_name = "appGwFrontendIP"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    firewall_policy_id             = azurerm_web_application_firewall_policy.waf_policy.id
  }

  # Request Routing Rule
  request_routing_rule {
    name                       = "appGwRoutingRule"
    rule_type                  = "PathBasedRouting"
    http_listener_name         = "appGwHttpListener"
    backend_address_pool_name  = "appGwBackendPool"
    backend_http_settings_name = "appGwBackendHttpSettings"
    priority                   = 100
    url_path_map_name          = "appGwUrlPathMap" # This is the path-based routing map
  }

  url_path_map {
    # This is where you define path-based routing rules
    # You can define multiple path rules here
    # This is also asociated with the per URI WAF policy
    name                               = "appGwUrlPathMap"
    default_backend_address_pool_name  = "appGwBackendPool"
    default_backend_http_settings_name = "appGwBackendHttpSettings"

    path_rule {
      name                       = "defaultPathRule"
      paths                      = ["/test*", "/api/*"]
      backend_address_pool_name  = "appGwBackendPool"
      backend_http_settings_name = "appGwBackendHttpSettings"
      firewall_policy_id         = azurerm_web_application_firewall_policy.waf_policy_uri.id
    }
  }

  # Gateway IP Configuration
  gateway_ip_configuration {
    name      = "appGwIpConfiguration"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }
}

# Output the Public IP address of the Application Gateway
output "application_gateway_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_public_ip.ip_address
}
