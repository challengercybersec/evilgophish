# Configure the Azure providerPackage Control: terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

#/**
  backend "azurerm" {
    storage_account_name  = "ziccarellistrg"
    container_name        = "terraformcontainer"
    key                   = "ardillas.tfstate"
    access_key            = "RTcJ26E0yABSWX2NX9F2QbvMtvyLGA/riPRhx1UpLSBeR6mx+tggC/oh8KEojiDJ4ty5lwulDGoT+AStc0E+7w=="
  }
#*/

}

provider "azurerm" {
  features {}
  subscription_id             =  var.subscription_id
  client_id                   =  var.client_id
  client_secret               =  var.client_secret
  tenant_id                   =  var.tenant_id
}