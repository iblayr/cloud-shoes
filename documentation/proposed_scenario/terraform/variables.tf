variable "location_rg" {
    description = "Location of the resource group"
    default     = "uksouth"
}

variable "location_vnet_hub" {
    description = "Location of the virtual network VNET-HUB"
    default     = "uksouth"
}

variable "location_vnet_spoke01" {
    description = "Location of the virtual network VNET-SPOKE01"
    default     = "northeurope"
}

variable "location_vnet_spoke02" {
    description = "Location of the virtual network VNET-SPOKE02"
    default     = "westeurope"
}

variable "username" {
    description = "Username for Virtual Machines"
    default     = "admin.azure"
}

variable "password" {
    description = "Password for Virtual Machines"
    default     = "Partiunuvem@2023"
}

variable "vmsize" {
    description = "Size of the VMs"
    default     = "Standard_B2s"
}