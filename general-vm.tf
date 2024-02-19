resource "azurerm_resource_group" "compute_rg" {
  name     = var.compute_rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_proximity_placement_group" "placement_group_az1" {
  name                = "ProximityPlacementGroupAz1"
  location            = var.location
  resource_group_name = azurerm_resource_group.compute_rg.name
  zone                = 1
  allowed_vm_sizes    = [var.vm_size]
  tags                = var.tags
}

resource "azurerm_proximity_placement_group" "placement_group_az2" {
  name                = "ProximityPlacementGroupAz2"
  location            = var.location
  resource_group_name = azurerm_resource_group.compute_rg.name
  zone                = 2
  allowed_vm_sizes    = [var.vm_size]
  tags                = var.tags
}