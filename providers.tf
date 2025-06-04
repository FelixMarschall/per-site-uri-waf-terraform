# Configure the AzureRM Provider
# Ensure you are logged in to Azure CLI (e.g., `az login`)
provider "azurerm" {
  features {}
  subscription_id = "" # Your Azure subscription ID
  tenant_id       = "" # Your Azure tenant ID
}