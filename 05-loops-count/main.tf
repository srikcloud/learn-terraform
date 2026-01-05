resource "null_resource" "test" {
    count = 10
}

output "test" {
  value = null_resource.test[*].id
}

resource "null_resource" "testx" {
}

output "test" {
  value = null_resource.testx.id
}