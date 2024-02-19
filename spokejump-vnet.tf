module "spokejumpnetwork" {
  source                  = "./modules/spokedefault"
  vnet_name               = var.spokejump_vnet_name
  resource_group_name     = var.spokejump_rg_name
  location                = var.location
  address_space           = var.spokejump_address_space
  subnet_prefixes         = var.spokejump_subnet_prefixes
  subnet_names            = var.spokejump_subnet_names
  hub-resource_group_name = azurerm_resource_group.rg_hub.name
  hub-vnet_name           = azurerm_virtual_network.vnet_hub.name
  hub-vnet_id             = azurerm_virtual_network.vnet_hub.id
  afw-private-ip          = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  hub-vnet_address_space  = tostring(var.vnet_hub-address_space[0])
  tags                    = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "afw_policy_spokejump_rcg" {
  name               = "spokejump-rcg"
  firewall_policy_id = azurerm_firewall_policy.afw_policy.id
  priority           = 201

  network_rule_collection {
    name     = "spokejump-net-rc"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_allow_ssh_rdp_to_spokejumpvm"
      protocols             = ["TCP"]
      source_addresses      = [var.full-address_space]
      destination_addresses = [module.linuxvmjump.vmnicip]
      destination_ports     = ["22", "3389"]
    }
  }
}