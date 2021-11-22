# Hub-Spoke + hub firewall + Service Endpoint Policy to control egress traffic at granular level

Azure Databricks is an Azure Managed Service, as of 20211122, it's not possible to associate custom `service endpoint policy` on subnets that hosts Azure Managed Services. See limitations section: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoint-policies-overview#configuration

Service endpoint policy is used for granular level access control to specific resources, for example storage accounts. 

This template provides a workaround to achieve similar objective and deploys:
1. Hub-Spoke networking with egress firewall to control all outbound traffic, e.g. to pypi.org.
2. Service Endpoint connection to storage accounts.
3. Service Endpoint Policy applied to have granular access control to specific storage accounts.


Your outbound traffic from Data Plane of Databricks, will be controlled by firewall rules; in addition, you can enforce granular access control to specific storage account, using service endpoint policy attached to firewall subnet. Traffic to storage accounts will be through service endpoints.

You need to add storage accounts into firewall FQDN rules. Then to associate a service endpoint policy to firewall subnet to allow granular egress control.

Resources to be created:
* Resource group with random prefix
* Tags, including `Owner`, which is taken from `az account show --query user`
* VNet with public and private subnet and subnet to host private endpoints
* Hub-Spoke topology, with hub firewall in hub vnet's subnet.
* Service endpoint policy that allows access to specific storage accounts.

## Warnings:
Service Endpoints will not bypass firewall.
You should not attach service endpoint policy when updating the firewall rules since firewall sits inside the subnet. 
Instead, update firewall rules first. Attach policy as the very last step.


## Scenario:
Given 2 storage accounts: 
1. randomallowedstorage
2. randomdeniedstorage
   
We configured in service endpoint policy to allow access to randomallowedstorage only.

## Definitions:

`Firewall: if we have FQDN rules to allow connection to ADLS.`

`Service Endpoint: if we have enabled service endpoint on f/w subnet.`

`Policy Attached: if a sep policy will be attached to f/w subnet.`


## Test Results:

| Firewall | Service Endpoint | Policy Attached | Connection Result                              | Granular Outbound Control                                             |
| -------- | ---------------- | --------------- | ---------------------------------------------- | --------------------------------------------------------------------- |
| No       | No               | No              | Cannot Connect to any storage                  | N.A.                                                                  |
| No       | Yes              | No              | Cannot Connect to any storage                  | N.A.                                                                  |
| No       | Yes              | Yes             | Cannot Connect to any storage                  | N.A.                                                                  |
| Yes      | No               | No              | Connect to any storage                         | Granular control using fqdn rules; public endpoint of storage         |
| Yes      | Yes              | No              | Connect to any storage; using service endpoint | Since no policy attached to f/w subnet, we can connect to all storage |
| Yes      | Yes              | Yes             | Granular connection using sep policy           | Connected to ALLOWED storage, deny conncetion to DENIED storage       |

## Getting Started
1. Clone this repo to your local machine.
2. Run `terraform init` to initialize terraform and get provider ready.
3. Change `terraform.tfvars` values to your own values.
4. Inside the local project folder, run `terraform apply` to create the resources.


<!-- BEGIN_TF_DOCS -->
Azure Databricks workspace in custom VNet

Module creates:
* Resource group with random prefix
* Tags, including `Owner`, which is taken from `az account show --query user`
* VNet with public and private subnet
* Databricks workspace

## Requirements

| Name                                                                         | Version |
| ---------------------------------------------------------------------------- | ------- |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)          | =2.83.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | 0.3.10  |

## Providers

| Name                                                             | Version |
| ---------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)    | 2.83.0  |
| <a name="provider_external"></a> [external](#provider\_external) | 2.1.0   |
| <a name="provider_random"></a> [random](#provider\_random)       | 3.1.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                                          | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/databricks_workspace)                                                     | resource    |
| [azurerm_firewall.hubfw](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/firewall)                                                                            | resource    |
| [azurerm_firewall_application_rule_collection.adbfqdn](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/firewall_application_rule_collection)                  | resource    |
| [azurerm_firewall_network_rule_collection.adbfnetwork](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/firewall_network_rule_collection)                      | resource    |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/network_security_group)                                                 | resource    |
| [azurerm_public_ip.fwpublicip](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/public_ip)                                                                     | resource    |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/resource_group)                                                                 | resource    |
| [azurerm_route_table.adbroute](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/route_table)                                                                   | resource    |
| [azurerm_storage_account.allowedstorage](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/storage_account)                                                     | resource    |
| [azurerm_storage_account.deniedstorage](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/storage_account)                                                      | resource    |
| [azurerm_subnet.hubfw](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet)                                                                                | resource    |
| [azurerm_subnet.plsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet)                                                                             | resource    |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet)                                                                              | resource    |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet)                                                                               | resource    |
| [azurerm_subnet_network_security_group_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet_network_security_group_association)        | resource    |
| [azurerm_subnet_network_security_group_association.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet_network_security_group_association)         | resource    |
| [azurerm_subnet_route_table_association.privateudr](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet_route_table_association)                           | resource    |
| [azurerm_subnet_route_table_association.publicudr](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet_route_table_association)                            | resource    |
| [azurerm_subnet_service_endpoint_storage_policy.allowedstoragepolicy](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/subnet_service_endpoint_storage_policy) | resource    |
| [azurerm_virtual_network.hubvnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/virtual_network)                                                            | resource    |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/virtual_network)                                                               | resource    |
| [azurerm_virtual_network_peering.hubvnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/virtual_network_peering)                                            | resource    |
| [azurerm_virtual_network_peering.spokevnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/resources/virtual_network_peering)                                          | resource    |
| [random_string.naming](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                                                 | resource    |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.83.0/docs/data-sources/client_config)                                                             | data source |
| [external_external.me](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)                                                                          | data source |

## Inputs

| Name                                                                                                           | Description | Type        | Default           | Required |
| -------------------------------------------------------------------------------------------------------------- | ----------- | ----------- | ----------------- | :------: |
| <a name="input_dbfs_prefix"></a> [dbfs\_prefix](#input\_dbfs\_prefix)                                          | n/a         | `string`    | `"dbfs"`          |    no    |
| <a name="input_firewallfqdn"></a> [firewallfqdn](#input\_firewallfqdn)                                         | n/a         | `list(any)` | n/a               |   yes    |
| <a name="input_hubcidr"></a> [hubcidr](#input\_hubcidr)                                                        | n/a         | `string`    | `"10.178.0.0/20"` |    no    |
| <a name="input_metastoreip"></a> [metastoreip](#input\_metastoreip)                                            | n/a         | `string`    | n/a               |   yes    |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip)                                     | n/a         | `bool`      | `true`            |    no    |
| <a name="input_private_subnet_endpoints"></a> [private\_subnet\_endpoints](#input\_private\_subnet\_endpoints) | n/a         | `list`      | `[]`              |    no    |
| <a name="input_rglocation"></a> [rglocation](#input\_rglocation)                                               | n/a         | `string`    | `"southeastasia"` |    no    |
| <a name="input_sccip"></a> [sccip](#input\_sccip)                                                              | n/a         | `string`    | n/a               |   yes    |
| <a name="input_spokecidr"></a> [spokecidr](#input\_spokecidr)                                                  | n/a         | `string`    | `"10.179.0.0/20"` |    no    |
| <a name="input_webappip"></a> [webappip](#input\_webappip)                                                     | n/a         | `string`    | n/a               |   yes    |
| <a name="input_workspace_prefix"></a> [workspace\_prefix](#input\_workspace\_prefix)                           | n/a         | `string`    | `"adb"`           |    no    |

## Outputs

| Name                                                                                                                                                           | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_arm_client_id"></a> [arm\_client\_id](#output\_arm\_client\_id)                                                                                | n/a         |
| <a name="output_arm_subscription_id"></a> [arm\_subscription\_id](#output\_arm\_subscription\_id)                                                              | n/a         |
| <a name="output_arm_tenant_id"></a> [arm\_tenant\_id](#output\_arm\_tenant\_id)                                                                                | n/a         |
| <a name="output_azure_region"></a> [azure\_region](#output\_azure\_region)                                                                                     | n/a         |
| <a name="output_databricks_azure_workspace_resource_id"></a> [databricks\_azure\_workspace\_resource\_id](#output\_databricks\_azure\_workspace\_resource\_id) | n/a         |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group)                                                                               | n/a         |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url)                                                                                  | n/a         |
<!-- END_TF_DOCS -->