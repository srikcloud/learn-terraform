variable "x" {
  default = 10
}

output "x" {
  value = var.x
}

## Variable data types
# string
# number
# boolean
# string require double quotes, number & boolean doesnt require quotes

variable "str" {
  default = "Hello"
}

variable "num" {
  default = 20
}

variable "mybool" {
  default = true
}

# when we access the varaible, irrespective of type you can access it with var.var-name
# variable requires to be in quotes if the variable is part of other characters, also need to access that with ${var.var-name}

output "str" {
  value = "${var.str}, steve"
}

## variable types
# Normal
# List
# Map / Dict

variable "a" {
  default = " this is a normal variable"
}

# the values in the list can comprise multiple data types also
variable "b" {
  default = [
    1,
    2,
    "abc",
    false
  ]
}

variable "c" {
  default = {
    x = 10
    y = 20
    z = "abc"
  }
}

output "b1" {
  value = var.b[0]
}

output "c1" {
  value = var.c["x"]
}

## variable from command line
variable "cli" {
}
output "command-line-variable" {
  value = var.cli
}

## variable from terraform .tfvars
variable "v1" {}

output "v1" {
  value = var.v1
}

variable "env" {}

output "env" {
  value = var.env
}