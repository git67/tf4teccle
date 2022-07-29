terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.78.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id = var.az_creds["subscription_id"]
  tenant_id       = var.az_creds["tenant_id"]
}

# module call
module "poc" {
  source = "./modules/base"

  # rg name
  rg_name = "RG_TF_POC_LB"

  # namespace
  namespace = "tfpoc"

  # az location
  location = "germanywestcentral"

  # vnet/subnet cidr
  vnet_address_space      = ["10.1.0.0/16"]
  subnet_address_prefixes = ["10.1.0.0/24"]

  # admin user vm
  vm_admin_username = "vm_adm"

  # count vm
  # keep in mind, number of quotient from vm_count divided by av_zones must be integer
  vm_count = 12
  av_zones = ["1","2","3"]
  #av_zones = ["1"]
}

