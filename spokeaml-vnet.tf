module "spokeamlnetwork" {
  source                  = "./modules/spokeaml"
  vnet_name               = var.spokeaml_vnet_name
  resource_group_name     = var.spokeaml_rg_name
  location                = var.location
  address_space           = var.spokeaml_address_space
  subnet_prefixes         = var.spokeaml_subnet_prefixes
  subnet_names            = var.spokeaml_subnet_names
  hub-resource_group_name = azurerm_resource_group.rg_hub.name
  hub-vnet_name           = azurerm_virtual_network.vnet_hub.name
  hub-vnet_id             = azurerm_virtual_network.vnet_hub.id
  afw-private-ip          = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  hub-vnet_address_space  = tostring(var.vnet_hub-address_space[0])
  tags                    = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "afw_policy_spokeaml_rcg" {
  name               = "spokeaml-rcg"
  firewall_policy_id = azurerm_firewall_policy.afw_policy.id
  priority           = 203

  //TODO FIX Fule (Dummy)
  network_rule_collection {
    name     = "spokeaml-net-rc"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_allow_https_to_spokeaml"
      protocols             = ["TCP"]
      source_addresses      = [var.full-address_space]
      destination_addresses = [var.full-address_space]
      destination_ports     = ["443"]
    }
  }
}