#This is the main code

#Resource Ggroup
resource "azurerm_resource_group" "rg_evilgophish" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    "ICO" = "challenger_bot"
  }
}

#Create NSG

resource "azurerm_network_security_group" "nsg_evilgophish" {
  name                = "NSG_evilgophish"
  location            = azurerm_resource_group.rg_evilgophish.location
  resource_group_name = azurerm_resource_group.rg_evilgophish.name
  tags                = azurerm_resource_group.rg_evilgophish.tags
  security_rule {
    name                       = "http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http2"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http3"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http4"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "3443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "http5"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range    = "3333"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
}

#Create storage account  and container

#resource "azurerm_storage_account" "storageaccount" {
#  name                     = var.storage_account_name
#  resource_group_name      = var.resource_group_name
#  location                 = var.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}

#resource "azurerm_storage_container" "container" {
#  name                  = var.container_name
#  storage_account_name  = azurerm_storage_account.example.name
#  container_access_type = "private"
#}



###-*------------





#Create Vnet
resource "azurerm_virtual_network" "vnet_evilgophish" {
  name                = "evilgophish-network"
  location            = azurerm_resource_group.rg_evilgophish.location
  resource_group_name = azurerm_resource_group.rg_evilgophish.name
  address_space       = [var.network-vnet-cidr]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  tags                = azurerm_resource_group.rg_evilgophish.tags
}

resource "azurerm_subnet" "ubuntu_subnet" {
  name                 = "ubuntu-subnet"
  resource_group_name  = azurerm_resource_group.rg_evilgophish.name
  virtual_network_name = azurerm_virtual_network.vnet_evilgophish.name
  address_prefixes     = [var.network-subnet-cidr-gophish]

}

resource "azurerm_subnet" "testing_subnet" {
  name                 = "testing-subnet"
  resource_group_name  = azurerm_resource_group.rg_evilgophish.name
  virtual_network_name = azurerm_virtual_network.vnet_evilgophish.name
  address_prefixes     = [var.network-subnet-cidr-testing]


}


####---###


#Creating Public IP


resource "azurerm_public_ip" "pip01" {
  name                         = "pip-ziccarelli"
  location                     = azurerm_resource_group.rg_evilgophish.location
  resource_group_name          = azurerm_resource_group.rg_evilgophish.name
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 30
}


#Network Interface


resource "azurerm_network_interface" "nic" {
  name                = "nic_terraform"
  location            = azurerm_resource_group.rg_evilgophish.location
  resource_group_name = azurerm_resource_group.rg_evilgophish.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.ubuntu_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01.id
  }
}

#----
#CREATE vm

resource "azurerm_linux_virtual_machine" "gophising" {
  name                = "gophising"
  resource_group_name = azurerm_resource_group.rg_evilgophish.name
  location            = azurerm_resource_group.rg_evilgophish.location
  size                = "Standard_B1s"
  admin_username      = "rootmebaby"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "rootmebaby"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmRkD0tSGGPdisK7PR48xup8caM02fb5AEqRdxOm5yF3M/50YfCXCyIeF5xmzlPuSbtT1iV5m+d92LWhEBsHBRaQhKzTh7dWxZk+jWGCvXdH3CgIHAISDxcyKVyK8ML6GCwGbDBSTX5bo24OfCqIRum1gMZ4uoJELHOPTkpPp3lZQbAHEwYI6vBQznKAsOIflahOGv7x74kQyOqYXsrRdqHX9vUgiGehOjJrYb7kDoiRnD+jOizY5CkxTNg/sEmmyV72ZJGd1K48sPq4P99y2x6ZV/MBILkKqpr22G8Fy0hKsWRHMG2QS9jI5RD88hlJoykE5zjl8qkLQt7soDYQtMxuwxoLo+oxYnW3W4Mvc72jILurnlz910MEyvnC3VERk5hdApp09eTKRiEFluYs5G36YnhPN4BsfORMQooIvrzFt7Y3kv5qwLsDy77Nxl+MxwQxZ1oQ2/bsv3koAkhqDNHaalSafPukPziVwWKVqDQHfIfJXi/UaVdr9DGMdNOoE= generated-by-azure"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}



#---


#### Creaton of CDN

/*
resource "azurerm_cdn_profile" "cdn_profile" {
  name                = var.cdn_profile_name
  location            = azurerm_resource_group.rg_evilgophish.location
  resource_group_name = azurerm_resource_group.rg_evilgophish.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdn_endpoint_gophish" {
  name                = var.cdn_endpoint_name_gophish
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.rg_evilgophish.location
  resource_group_name = azurerm_resource_group.rg_evilgophish.name
  origin_host_header  = var.cdn_origin_host_gophish
  querystring_caching_behaviour = "BypassCaching"

  origin {
    name      = var.cdn_endpoint_name_gophish
    host_name = var.cdn_origin_host_gophish
  }

  delivery_rule{
    name = "nocache"
    order = 1
    
    query_string_condition {
      operator = "Any"
    }

    
    url_path_condition {
      operator = "Any"
    }

    cache_expiration_action {
      behavior =  "BypassCache"
    }
  }
}

resource "azurerm_cdn_endpoint" "cdn_endpoint_evilginx1" {
  name                = var.cdn_endpoint_name_evilginx1
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.azure_resource.location
  resource_group_name = azurerm_resource_group.azure_resource.name
  origin_host_header  = var.cdn_origin_hostheader_evilginx1
  querystring_caching_behaviour = "BypassCaching"

  origin {
    name      = var.cdn_endpoint_name_evilginx1
    host_name = var.cdn_origin_host_evilginx1
  }

  delivery_rule{
    name = "nocache"
    order = 1
    
    query_string_condition {
      operator = "Any"
    }

    
    url_path_condition {
      operator = "Any"
    }

    cache_expiration_action {
      behavior =  "BypassCache"
    }
  }
}

resource "azurerm_cdn_endpoint" "cdn_endpoint_evilginx2" {
  name                = var.cdn_endpoint_name_evilginx2
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.azure_resource.location
  resource_group_name = azurerm_resource_group.azure_resource.name
  origin_host_header  = var.cdn_origin_hostheader_evilginx2
  querystring_caching_behaviour = "BypassCaching"

  origin {
    name      = var.cdn_endpoint_name_evilginx2
    host_name = var.cdn_origin_host_evilginx2
  }

  delivery_rule{
    name = "nocache"
    order = 1
    
    query_string_condition {
      operator = "Any"
    }

    
    url_path_condition {
      operator = "Any"
    }

    cache_expiration_action {
      behavior =  "BypassCache"
    }
  }
}

*/