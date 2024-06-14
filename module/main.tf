data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "dev-project2-remotestate"
    storage_account_name = "project2remotestate"
    container_name       = "network-terraform-state"
    key                  = "nw-terraform.tfstate"
  }
}


locals {
  vnets   = data.terraform_remote_state.network.outputs.vnets
  subnets = data.terraform_remote_state.network.outputs.vnets.subnets
}

locals {
  nsg_name = {
    for subnet in local.subnets : subnet.name => "NSG-${subnet.name}"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.nsg_name

  subnet_id                 = local.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}