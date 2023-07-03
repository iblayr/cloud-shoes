variable "location_rg" {
    description = "Location of the resource group"
    default     = "centralus"
}

variable "location_vnet_hub" {
    description = "Location of the virtual network VNET-HUB"
    default     = "centralus"
}

variable "location_vnet_spoke01" {
    description = "Location of the virtual network VNET-SPOKE01"
    default     = "eastus"
}

variable "location_vnet_spoke02" {
    description = "Location of the virtual network VNET-SPOKE02"
    default     = "westus"
}