data "azurerm_resource_group" "rg" {
  name     = "afs-resize-terraform"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnetname}-vnet"
  address_space       = var.vnetcidr
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnetname}-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnetcidr
}

# Create public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.publicip}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
  zones = var.zonespip
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.nsgname}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"  # RDP port
    source_address_prefix      = "165.1.238.44"  # Specific source IP
    destination_address_prefix = "*"
}

}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.nicname}-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "${var.nicname}-nic-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "${var.vmname}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  zone = var.zonesvm
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.filestoragename}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
  allow_nested_items_to_be_public = false
}

# File Share
resource "azurerm_storage_share" "FSShare" {
  name                 = "${var.fsname}"
  storage_account_name = azurerm_storage_account.storage.name
  quota = 100
  depends_on           = [azurerm_storage_account.storage]
}

#Add role assignment
resource "azurerm_role_assignment" "role" {
  count = var.enable_role_assignment ? 1 : 0
  scope = azurerm_storage_account.storage.id
  role_definition_name = "${var.roledefinition}"
  principal_id = "${var.principal_id}"
  
}
