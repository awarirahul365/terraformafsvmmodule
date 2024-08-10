terraform {

    required_providers {
      azurerm={
        source = "hashicorp/azurerm"
        version = "~>3.43.0"
      }
    }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id = "b437f37b-b750-489e-bc55-43044286f6e1"
}

module "createvmafs" {
  source = "./modules/vmafsmodule"
  for_each = var.virtual_machines
  vmname = each.key
  vnetname = each.value.vnetname
  vnetcidr = each.value.vnetcidr
  subnetname = each.value.subnetname
  subnetcidr = each.value.subnetcidr
  publicip = each.value.publicip
  zonespip =each.value.zonespip
  nsgname = each.value.nsgname
  nicname = each.value.nicname
  zonesvm = each.value.zonesvm
  filestoragename = each.value.filestoragename
  fsname = each.value.fsname
  roledefinition = each.value.roledefinition
  principal_id = each.value.principal_id
  enable_role_assignment = each.value.enable_role_assignment
}