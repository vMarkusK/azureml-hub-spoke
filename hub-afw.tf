resource "random_id" "randomidfirewall" {
  byte_length = 4
}

resource "azurerm_public_ip" "afw_pip" {
  name                = "afw_pip"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "afw_pip-${random_id.randomidfirewall.hex}"
  zones               = ["1"]
  tags                = var.tags
}

resource "azurerm_firewall" "afw" {
  name                = "afw"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.afw_policy.id
  threat_intel_mode   = "Alert"
  zones               = ["1"]

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_hub[0].id
    public_ip_address_id = azurerm_public_ip.afw_pip.id
  }

  tags = var.tags
}

resource "azurerm_firewall_policy" "afw_policy" {
  name                = "afw_policy"
  resource_group_name = azurerm_resource_group.rg_hub.name
  location            = var.location

  dns {
    proxy_enabled = true
  }

  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "afw_policy_default_rcg" {
  name               = "default-rcg"
  firewall_policy_id = azurerm_firewall_policy.afw_policy.id
  priority           = 200
  application_rule_collection {
    name     = "default-app-rc"
    priority = 200
    action   = "Allow"
    rule {
      name = "app_rule_allow_ubuntu_http"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = [var.full-address_space]
      destination_fqdns = ["*.ubuntu.com"]
    }
  }

  network_rule_collection {
    name     = "default-net-rc"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_allow_icmp"
      protocols             = ["ICMP"]
      source_addresses      = [var.full-address_space]
      destination_addresses = [var.full-address_space]
      destination_ports     = ["*"]
    }
  }
}