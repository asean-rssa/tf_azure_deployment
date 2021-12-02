# Create Security Group to access web
resource "azurerm_network_security_group" "web-linux-vm-nsg" {
  depends_on          = [azurerm_resource_group.this]
  name                = "hwang-web-linux-vm-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  security_rule {
    name                       = "allow-any-inbound"
    description                = "allow-inbound"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-any-outbound"
    description                = "allow-outbound"
    priority                   = 201
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "allow-ssh"
    description                = "allow-ssh"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "inbound1" {
  name                        = "inbound1"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}

resource "azurerm_network_security_rule" "webapp" {
  name                        = "webapp"
  priority                    = 300
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureDatabricks"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}

resource "azurerm_network_security_rule" "azuresqlrule" {
  name                        = "azuresqlrule"
  priority                    = 301
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "sql"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}


resource "azurerm_network_security_rule" "storage" {
  name                        = "storage"
  priority                    = 302
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}

resource "azurerm_network_security_rule" "workernodes" {
  name                        = "workernodes"
  priority                    = 303
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}


resource "azurerm_network_security_rule" "eventhub" {
  name                        = "eventhub"
  priority                    = 304
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "9093"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "EventHub"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}


resource "azurerm_network_security_rule" "vnet" {
  name                        = "vnet"
  priority                    = 305
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.web-linux-vm-nsg.name
}



# Associate the web NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "web-linux-vm-nsg-association" {
  depends_on                = [azurerm_network_security_group.web-linux-vm-nsg]
  subnet_id                 = azurerm_subnet.proxysubnet.id
  network_security_group_id = azurerm_network_security_group.web-linux-vm-nsg.id
}

# Get a Static Public IP
resource "azurerm_public_ip" "web-linux-vm-ip" {
  depends_on          = [azurerm_resource_group.this]
  name                = "linux-${random_string.naming.result}-vm-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
}

# Create Network Card for web VM
resource "azurerm_network_interface" "web-linux-vm-nic" {
  depends_on          = [azurerm_public_ip.web-linux-vm-ip]
  name                = "linux-${random_string.naming.result}-vm-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.proxysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-linux-vm-ip.id
  }
}

# Create Linux VM with web server
resource "azurerm_linux_virtual_machine" "web-linux-vm" {
  depends_on            = [azurerm_network_interface.web-linux-vm-nic]
  name                  = "linux-${random_string.naming.result}-vm"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.web-linux-vm-nic.id]
  size                  = "Standard_F2"
  admin_username        = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    name                 = "linux-${random_string.naming.result}-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  computer_name                   = "linux-${random_string.naming.result}-vm"
  disable_password_authentication = true
}