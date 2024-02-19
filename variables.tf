variable "location" {
  description = "Location for all resources"
  type        = string
  default     = "swedencentral"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    applicationname = "SpokeVendingMachine"
    environment     = "Dev"
    supportgroup    = "Markus Kraus"
  }
}

variable "full-address_space" {
  description = "Full Adress Space of the Hub&Spoke Topo"
  type        = string
  default     = "10.0.0.0/8"
}

// Hub
variable "rg_hub-name" {
  description = "Name of the Hub RG"
  type        = string
  default     = "rg-net-hub-001"
}

variable "vnet_hub-name" {
  description = "Name of the Hub VNet"
  type        = string
  default     = "vnet_hub-001"
}

variable "vnet_hub-address_space" {
  description = "Address Space of the Hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "hub-subnet_names" {
  description = "Subnet Names of the Hub VNet"
  type        = list(string)
  default     = ["AzureFirewallSubnet", "NetworkGatewaySubnet", "ApplicationGatewaySubnet"]
}

variable "hub-subnet_prefixes" {
  description = "Subnet Prefixes of the Hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26"]
}

// spokejump
variable "spokejump_rg_name" {
  description = "spokejump RG name"
  type        = string
  default     = "rg-spokejump-001"
}

variable "spokejump_vnet_name" {
  description = "spokejump vnet name"
  type        = string
  default     = "vnet-spokejump-001"
}

variable "spokejump_address_space" {
  description = "spokejump Address Space"
  type        = string
  default     = "10.110.0.0/16"
}

variable "spokejump_subnet_names" {
  description = "spokejump Subnet Names"
  type        = list(string)
  default     = ["JumpLinux", "JumpWindows"]
}

variable "spokejump_subnet_prefixes" {
  description = "spokejump Subnet prefixes"
  type        = list(string)
  default     = ["10.110.1.0/24", "10.110.2.0/24"]
}

// Spoke DNS
variable "spokedns_rg_name" {
  description = "spokedns RG name"
  type        = string
  default     = "rg-spokedns-001"
}

variable "spokedns_vnet_name" {
  description = "spokedns vnet name"
  type        = string
  default     = "vnet-spokedns-001"
}

variable "spokedns_address_space" {
  description = "spokedns Address Space"
  type        = string
  default     = "10.100.0.0/16"
}

variable "spokedns_subnet_names" {
  description = "spokedns Subnet Names"
  type        = list(string)
  default     = ["DnsInbound", "DnsOutbound"]
}

variable "spokedns_subnet_prefixes" {
  description = "spokedns Subnet prefixes"
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
}

// Spoke AML
variable "spokeaml_rg_name" {
  description = "spokeaml RG name"
  type        = string
  default     = "rg-spokeaml-001"
}

variable "spokeaml_vnet_name" {
  description = "spokeaml vnet name"
  type        = string
  default     = "vnet-spokeaml-001"
}

variable "spokeaml_address_space" {
  description = "spokeaml Address Space"
  type        = string
  default     = "10.101.0.0/16"
}

variable "spokeaml_subnet_names" {
  description = "spokeaml Subnet Names"
  type        = list(string)
  default     = ["compute", "aks", "workspoace"]
}

variable "spokeaml_subnet_prefixes" {
  description = "spokeaml Subnet prefixes"
  type        = list(string)
  default     = ["10.101.1.0/24", "10.101.2.0/24", "10.101.3.0/24"]
}


// Compute General
variable "compute_rg_name" {
  description = "Compute RG Name"
  type        = string
  default     = "rg-compute-001"
}

variable "cloudconfig_file_linux" {
  description = "The location of the cloud init configuration file."
  type        = string
  default     = "cloudconfig_linux.tpl"
}

variable "vm_admin_user" {
  description = "Username for Virtual Machines"
  type        = string
  default     = "azureuser"
}
variable "vm_admin_pwd" {
  description = "Password for Virtual Machines"
  type        = string
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B1s"
}

// Compute spokejump
variable "spokejump_vm_hostname" {
  description = "Hostname of spokejump VM"
  type        = string
  default     = "vm-jump-dev-001"
}

