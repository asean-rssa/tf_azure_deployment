output "public_key" {
  value = tls_private_key.splunk_ssh.public_key_openssh
}

output "arm_client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "arm_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "arm_tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "azure_region" {
  value = local.location
}

output "resource_group" {
  value = azurerm_resource_group.this.name
}

output "file_url" {
  value = module.adls_content.file_url
}
