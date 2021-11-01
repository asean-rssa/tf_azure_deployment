resource "azurerm_private_endpoint" "dpcp" {
  name                = "dpcppvtendpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.plsubnet.id //private link subnet, in databricks spoke vnet


  private_service_connection {
    name                           = "ple-${var.workspace_prefix}-dpcp"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdpcp.id]
  }

}

resource "azurerm_private_dns_zone" "dnsdpcp" {
  name                = "devdpcplinkdatabricks.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "spokevnetconnection"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsdpcp.name
  virtual_network_id    = azurerm_virtual_network.this.id // connect to spoke vnet
}


resource "azurerm_private_dns_a_record" "example" { //add A record to the private dns zone
  name                = "test"
  zone_name           = azurerm_private_dns_zone.dnsdpcp.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.dpcp.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_dns_cname_record" "example" { //add CNAME record to the private dns zone
  name                = "${var.rglocation}.pl-auth"
  zone_name           = azurerm_private_dns_zone.dnsdpcp.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 60
  record              = azurerm_databricks_workspace.this.workspace_url
}
