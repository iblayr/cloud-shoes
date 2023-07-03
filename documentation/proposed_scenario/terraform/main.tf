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
    name                = "VNET-HUB"
    location            = var.location_vnet_hub
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "GatewaySubnet" {
    name                 = "GatewaySubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes     = ["10.0.240.0/24"]
}

resource "azurerm_subnet" "FirewallSubnet" {
    name                 = "AzureFirewallSubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes     = ["10.0.250.0/24"]
}

resource "azurerm_subnet" "HubSubnet" {
    name                 = "HubSubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub.name
    address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "spoke01" {
    name                = "VNET-SPOKE01"
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

resource "azurerm_subnet" "FrontEndSubnet" {
    name                 = "FrontEndSubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke01.name
    address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "BackEndSubnet" {
    name                 = "BackEndSubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke01.name
    address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_virtual_network" "spoke02" {
    name                = "VNET-SPOKE02"
    location            = var.location_vnet_spoke02
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.20.0.0/16"]

}

resource "azurerm_subnet" "DatabaseSubnet" {
    name                 = "DatabaseSubnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spoke02.name
    address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "IntegrationSubnet" {
    name                 = "IntegrationSubnet"
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
  subnet_id                 = azurerm_subnet.HubSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg-hub.id
}

resource "azurerm_network_security_group" "nsg_FrontEnd" {
  name                = "nsg_FrontEnd"
  location            = var.location_vnet_spoke01
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_front_assc" {
  subnet_id                 = azurerm_subnet.FrontEndSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg_FrontEnd.id
}

resource "azurerm_network_security_group" "nsg_BackEnd" {
  name                = "nsg_BackEnd"
  location            = var.location_vnet_spoke01
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_back_assc" {
  subnet_id                 = azurerm_subnet.BackEndSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg_BackEnd.id
}

resource "azurerm_network_security_group" "nsg_Database" {
  name                = "nsg_Database"
  location            = var.location_vnet_spoke02
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_database_assc" {
  subnet_id                 = azurerm_subnet.DatabaseSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg_Database.id
}

resource "azurerm_network_security_group" "nsg_Integration" {
  name                = "nsg_Integration"
  location            = var.location_vnet_spoke02
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_integration_assc" {
  subnet_id                 = azurerm_subnet.IntegrationSubnet.id
  network_security_group_id = azurerm_network_security_group.nsg_Integration.id
}