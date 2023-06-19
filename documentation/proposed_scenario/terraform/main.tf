terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "rg-cloudshoes"
  location = var.location_rg
}

resource "azurerm_virtual_network" "hub" {
    name                = "vnet-hub"
    location            = var.location_vnet_hub
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "GatewaySubnet" {
    name                 = "GatewaySubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes     = ["10.0.250.0/24"]
}

resource "azurerm_subnet" "sub-hub" {
    name                 = "sub-hub"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "spoke01" {
    name                = "vnet-spoke01"
    location            = var.location_vnet_spoke01
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.10.0.0/16"]

}

resource "azurerm_subnet" "AppGatewaySubnet" {
    name                 = "AppGatewaySubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke01.name
    address_prefixes     = ["10.10.250.0/24"]
}

resource "azurerm_subnet" "sub-frontend" {
    name                 = "sub-frontend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke01.name
    address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "sub-backend" {
    name                 = "sub-backend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke01.name
    address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_virtual_network" "spoke02" {
    name                = "vnet-spoke02"
    location            = var.location_vnet_spoke02
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.20.0.0/16"]

}

resource "azurerm_subnet" "sub-database" {
    name                 = "sub-database"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke02.name
    address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "sub-integration" {
    name                 = "sub-integration"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke02.name
    address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_network_security_group" "nsg-hub" {
  name                = "nsg-hub"
  location            = var.location_vnet_hub
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_hub_assc" {
  subnet_id                 = azurerm_subnet.sub-hub.id
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
}

resource "azurerm_network_security_group" "nsg-spoke01" {
  name                = "nsg-spoke01"
  location            = var.location_vnet_spoke01
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_HTTP_80"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.10.1.4"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_spoke01_assc_front" {
  subnet_id                 = azurerm_subnet.sub-frontend.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke01.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_spoke01_assc_back" {
  subnet_id                 = azurerm_subnet.sub-backend.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke01.id
}

resource "azurerm_network_security_group" "nsg-spoke02" {
  name                = "nsg-spoke02"
  location            = var.location_vnet_spoke02
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_HTTP_80"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefixes = ["10.20.1.4", "10.20.2.4"]
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_spoke02_assc_data" {
  subnet_id                 = azurerm_subnet.sub-database.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke02.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_spoke02_assc_integra" {
  subnet_id                 = azurerm_subnet.sub-integration.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke02.id
}