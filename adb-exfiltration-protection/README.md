# Hub-Spoke + hub firewall + Service Endpoint Policy to control egress traffic at granular level

This template deploys:
1. Hub-Spoke networking with egress firewall to control all outbound traffic, e.g. to pypi.org.
2. Service Endpoint connection to storage accounts.
3. Service Endpoint Policy applied to have granular access control to specific storage accounts.

What does this mean:

With this deployment, traffic from user client to webapp (notebook UI), backend traffic from data plane to control plane will be through private endpoints. This terraform sample will create:
* Resource group with random prefix
* Tags, including `Owner`, which is taken from `az account show --query user`
* VNet with public and private subnet and subnet to host private endpoints
* Databricks workspace with private link to control plane, user to webapp and private link to dbfs


## Warnings:
Service Endpoints will not bypass firewall.

Given 2 storage accounts: 
1. fpdbhqallowedstorage
2. fpdbhqdeniedstorage

`Firewall: if we have FQDN rules to allow connection to ADLS.`

`Service Endpoint: if we have enabled service endpoint on f/w subnet.`

`Policy Attached: if a sep policy will be attached to f/w subnet.`


| Firewall | Service Endpoint | Policy Attached | Connection Result                              | Granular Outbound Control                                          |
| -------- | ---------------- | --------------- | ---------------------------------------------- | ------------------------------------------------------------------ |
| No       | No               | No              | Cannot Connect to any storage                  | N.A.                                                               |
| No       | Yes              | No              | Cannot Connect to any storage                  | N.A.                                                               |
| No       | Yes              | Yes             | Cannot Connect to any storage                  | N.A.                                                               |
| Yes      | No               | No              | Connect to any storage                         | Granular control using fqdn rules; public endpoint of adls         |
| Yes      | Yes              | No              | Connect to any storage; using service endpoint | Since no policy attached to f/w subnet, we can connect to all adls |
| Yes      | Yes              | Yes             | Granular connection using sep policy           | Connected to ALLOWED ADLS, deny conncetion to DENIED ADLS          |

## Getting Started
1. Clone this repo to your local machine.
2. Run `terraform init` to initialize terraform and get provider ready.
3. Change `terraform.tfvars` values to your own values.
4. Inside the local project folder, run `terraform apply` to create the resources.
