provider "azurerm" {
     features {}
     subscription_id = "f7fcf972-1a3d-456c-a347-914d12f8c308"
}

variable "nodes" {
  default = {
      test2 = {
        private_ip_address_allocation = "Static"
     }
      test1 = {
      }
   }
}

resource "azurerm_network_interface" "privateip" {
  for_each            = var.nodes
  name                = "${each.key}-ip"
  location            = "UK West"
  resource_group_name = "rg-roboshop"

  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = "/subscriptions/f7fcf972-1a3d-456c-a347-914d12f8c308/resourceGroups/rg-roboshop/providers/Microsoft.Network/virtualNetworks/roboshop-network/subnets/default"
    private_ip_address_allocation = length(try(each.value["private_ip_address_allocation"], "")) > 0 ? each.value["private_ip_address_allocation"] : "Dynamic"
  }
}

# condition ? true_val ? false_val
# condition in terraform are meant to pick up a value, not meant to run a resource or not