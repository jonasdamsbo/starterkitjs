terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tempresourcenameresourcegroup" # "jgdtestresourcegroup" # secret
      storage_account_name = "tempresourcenamestorageaccount" # "jgdteststorageaccount" # secret
      container_name       = "tempterraformcontainer" # "angularterraform" # secret
      key                  = "terraform.tfstate"
      access_key           = "tempstoragekey"
  }
}

provider "azurerm" {
  subscription_id = "tempsubscriptionid"
  features {}
  client_id       = "tempclientid"
  client_secret   = "tempclientsecret"
  tenant_id       = "temptenantid"
}

data "azurerm_resource_group" "exampleResourcegroup" {
  name = "tempresourcenameresourcegroup" #"jgdtestresourcegroup" # secret
}