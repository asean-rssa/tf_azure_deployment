output "splunk_public_ip" {
  value = azurerm_public_ip.splunk-nic-pubip.ip_address
}
