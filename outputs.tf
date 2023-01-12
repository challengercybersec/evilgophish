output "resource_group_name" {
  value = azurerm_resource_group.rg_evilgophish.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.gophising.public_ip_address
}