output "vm_username" {
  value = var.vm_admin_user
}

output "spokejump_vm_private_ip" {
  value = module.linuxvmjump.vmnicip
}

output "firewall_public_dns_fqdn" {
  value = azurerm_public_ip.afw_pip.fqdn
}