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

## Scenario:
Given 2 storage accounts: 
1. randomallowedstorage
2. randomdeniedstorage
   
We configured in service endpoint policy to allow access to randomallowedstorage only.

## Definitions:

`Firewall: if we have FQDN rules to allow connection to ADLS.`

`Service Endpoint: if we have enabled service endpoint on f/w subnet.`

`Policy Attached: if a sep policy will be attached to f/w subnet.`


Can we use firewall and also service endpoint policy on firewall subnet together?

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
