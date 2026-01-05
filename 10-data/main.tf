# data block is to get the information from the provider of existing resources.
data "azurerm_resource_group" "example" {
  name = "rg-roboshop"
}

output "id" {
  value = data.azurerm_resource_group.example
}

provider "azurerm" {
     features {}
     subscription_id = "f7fcf972-1a3d-456c-a347-914d12f8c308"
}