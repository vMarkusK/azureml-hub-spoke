resource "azurerm_resource_group" "rg-spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

// VNet
resource "azurerm_virtual_network" "vnet-spoke" {
  name                = var.vnet_name
  location            = var.location
  address_space       = ["${var.address_space}"]
  resource_group_name = azurerm_resource_group.rg-spoke.name
  dns_servers         = var.dns_servers
  tags                = var.tags
}

// SubNets
resource "azurerm_subnet" "subnet-spoke" {
  name                 = var.subnet_names[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  address_prefixes     = ["${var.subnet_prefixes[count.index]}"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
  count                = length(var.subnet_names)
}

// Peering
resource "azurerm_virtual_network_peering" "hubspoke" {
  name                      = "hub-${var.vnet_name}"
  resource_group_name       = var.hub-resource_group_name
  virtual_network_name      = var.hub-vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke.id
}

resource "azurerm_virtual_network_peering" "spokehub" {
  name                      = "${var.vnet_name}-hub"
  resource_group_name       = azurerm_resource_group.rg-spoke.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = var.hub-vnet_id
  allow_forwarded_traffic   = true
}

// Routing

resource "azurerm_route_table" "spoke-rt-table" {
  name                          = "rt-${var.vnet_name}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg-spoke.name
  tags                          = var.tags
}

resource "azurerm_route" "default-route" {
  name                          = "default-route-entry"
  resource_group_name           = azurerm_resource_group.rg-spoke.name
  route_table_name              = azurerm_route_table.spoke-rt-table.name
  address_prefix                = "0.0.0.0/0"
  next_hop_type                 = "VirtualAppliance"
  next_hop_in_ip_address        = var.afw-private-ip
}

resource "azurerm_route" "peering-route" {
  name                          = "peering-route-entry"
  resource_group_name           = azurerm_resource_group.rg-spoke.name
  route_table_name              = azurerm_route_table.spoke-rt-table.name
  address_prefix                = var.hub-vnet_address_space
  next_hop_type                 = "VirtualAppliance"
  next_hop_in_ip_address        = var.afw-private-ip
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  route_table_id = azurerm_route_table.spoke-rt-table.id
  subnet_id      = azurerm_subnet.subnet-spoke[count.index].id
  count          = length(azurerm_subnet.subnet-spoke)
}
