<!-- BEGIN_TF_DOCS -->
## What is Network Security Group Association

Azure Virtual Network (VNet) enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. Network Security Groups (NSG) are used to filter inbound and outbound traffic to network interfaces (NIC), VMs, and subnets.
NSG can be associated with what kind of resources? Network security group (NSG) can be associated to any virtual network subnet and/or network interface in a virtual machine.

```hcl
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)

- <a name="provider_terraform"></a> [terraform](#provider\_terraform)

## Resources

The following resources are used by this module:

- [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [terraform_remote_state.network](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

No modules.

This is sample Network Security Group using terraform module for learning purpose by Seenu.
<!-- END_TF_DOCS -->