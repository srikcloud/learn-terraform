provider "azurerm" {
     features {}
     subscription_id = "f7fcf972-1a3d-456c-a347-914d12f8c308"
}

variable "nodes" {
  default = {
     test1 = {
        vm_size               = "Standard_B2als_v2"
     }
     test2 = {
        vm_size               = "Standard_B2als_v2"
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
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "test" {
  for_each              = var.nodes
  name                  = "${each.key}-vm"
  location              = "UK West"
  resource_group_name   = "rg-roboshop"
  network_interface_ids = [azurerm_network_interface.privateip[each.key].id]
  vm_size               = "Standard_B2als_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
   id = "/subscriptions/f7fcf972-1a3d-456c-a347-914d12f8c308/resourceGroups/rg-roboshop/providers/Microsoft.Compute/images/local-devops-practice"
  }
  storage_os_disk {
    name              = "${each.key}-vm-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${each.key}-vm"
    admin_username = "azureuser"
    admin_password = "DevOps@123456"
  }
 os_profile_linux_config {
    disable_password_authentication = false
  }

}
