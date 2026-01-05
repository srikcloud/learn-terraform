resource "null_resource" "test" {
    count = 10
}

# count resource attributes are referred with resourcelabel.locallabel[*].attribute 
#(* denoting all values, if we want first value then [0])

output "test" {
  value = null_resource.test[*].id
}

resource "null_resource" "testx" {
}

output "testx" {
  value = null_resource.testx.id
}

## count is not a great one to start for looping, as it has its own problems

variable "nodes" {
  default = [
     "test1",
     "test2"
  ]
}

resource "azurerm_network_interface" "privateip" {
  count               = length(var.nodes)
  name                = "${var.nodes[count.index]}-ip"
  location            = "UK West"
  resource_group_name = "rg-roboshop"

  ip_configuration {
    name                          = "${var.nodes[count.index]}-ip"
    subnet_id                     = "/subscriptions/f7fcf972-1a3d-456c-a347-914d12f8c308/resourceGroups/rg-roboshop/providers/Microsoft.Network/virtualNetworks/roboshop-network/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "test" {
  count                 = length(var.nodes)
  name                  = "${var.nodes[count.index]}-vm"
  location              = "UK West"
  resource_group_name   = "rg-roboshop"
  network_interface_ids = [azurerm_network_interface.privateip[count.index].id]
  vm_size               = "Standard_B2als_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
   id = "/subscriptions/f7fcf972-1a3d-456c-a347-914d12f8c308/resourceGroups/rg-roboshop/providers/Microsoft.Compute/images/local-devops-practice"
  }
  storage_os_disk {
    name              = "${var.nodes[count.index]}-vm-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.nodes[count.index]}-vm"
    admin_username = "azureuser"
    admin_password = "DevOps@123456"
  }
 os_profile_linux_config {
    disable_password_authentication = false
  }

}
