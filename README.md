# Azure Application Gateway with Web Application Firewall (WAF)

This Terraform project sets up an Azure Application Gateway with Web Application Firewall (WAF) policies. The configuration includes global, per-site, and per-URI WAF policies to secure web applications.

## Medium article

[Medium Article](https://medium.com/@felixmarschall/configure-per-site-uri-waf-policies-azure-gateway-terraform-ffcfcf115f37)

## Project Structure

- **`providers.tf`**: Configures the AzureRM provider for Terraform.
- **`network.tf`**: Defines the Azure resource group, virtual network, subnet, and public IP address.
- **`waf_global.tf`**: Configures the global WAF policy.
- **`waf_per_site.tf`**: Configures the per-site WAF policy.
- **`waf_per_uri.tf`**: Configures the per-URI WAF policy.

## Features

1. **Global WAF Policy**:
   - Applies to all requests.
   - Includes managed OWASP rules and custom rules for global allow/block conditions.

2. **Per-Site WAF Policy**:
   - Applies to specific sites.
   - Includes custom rules for site-specific allow/block conditions.

3. **Per-URI WAF Policy**:
   - Applies to specific URI paths.
   - Includes custom rules for URI-specific allow/block conditions.

4. **Application Gateway**:
   - Configured with HTTP listener, backend pools, and routing rules.
   - Integrates WAF policies at different levels.

## Prerequisites

- Azure CLI installed and logged in (`az login`).
- Terraform installed.
- Subscription ID and Tenant ID for Azure.
# Azure Application Gateway with Web Application Firewall (WAF)

This Terraform project sets up an Azure Application Gateway with Web Application Firewall (WAF) policies. The configuration includes global, per-site, and per-URI WAF policies to secure web applications.

## Project Structure

- **`providers.tf`**: Configures the AzureRM provider for Terraform.
- **`network.tf`**: Defines the Azure resource group, virtual network, subnet, and public IP address.
- **`waf_global.tf`**: Configures the global WAF policy.
- **`waf_per_site.tf`**: Configures the per-site WAF policy.
- **`waf_per_uri.tf`**: Configures the per-URI WAF policy.
  
## Features

1. **Global WAF Policy**:
   - Applies to all requests.
   - Includes managed OWASP rules and custom rules for global allow/block conditions.

2. **Per-Site WAF Policy**:
   - Applies to specific sites.
   - Includes custom rules for site-specific allow/block conditions.

3. **Per-URI WAF Policy**:
   - Applies to specific URI paths.
   - Includes custom rules for URI-specific allow/block conditions.

4. **Application Gateway**:
   - Configured with HTTP listener, backend pools, and routing rules.
   - Integrates WAF policies at different levels.

## Prerequisites

- Azure CLI installed and logged in (`az login`).
- Terraform installed.
- Subscription ID and Tenant ID for Azure.
