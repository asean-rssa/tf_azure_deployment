# Automated process to deploy Azure Databricks Workspace with data exfiltration protection.

Include:
1. Hub-Spoke networking with egress firewall to control all outbound traffic, e.g. to pypi.org.
2. Private Link connection for backend traffic from data plane to control plane.
3. Private Link connection from user client to webapp service.
4. Private Link connection from data plane to dbfs storage.
5. (To Be Implemented) External Hive Metastore in your own subscription, with private endpoint connection.

Overall Architecture:
![alt text](../charts/adb-private-links.png?raw=true)

Warning: To use this deployment, you need to obtain access to private link feature (as of 2021.11 in private preview. Contact Databricks or Microsoft team for more details.

With this deployment, traffic from user client to webapp (notebook UI), backend traffic from data plane to control plane will be through private endpoints. This terraform sample will create:
* Resource group with random prefix
* Tags, including `Owner`, which is taken from `az account show --query user`
* VNet with public and private subnet and subnet to host private endpoints
* Databricks workspace with private link to control plane, user to webapp and private link to dbfs


## Getting Started
1. Clone this repo to your local machine.
2. Run `terraform init` to initialize terraform and get provider ready.
3. Change `terraform.tfvars` values to your own values.
4. Inside the local project folder, run `terraform apply` to create the resources.

## Inputs

Given 2 storage accounts: 
1. fpdbhqallowedstorage
2. fpdbhqdeniedstorage

`Firewall: if we have FQDN rules to allow connection to ADLS.`

`Service Endpoint: if we have enabled service endpoint on f/w subnet.`

`Policy Attached: if a sep policy will be attached to f/w subnet.`

| Firewall | Service Endpoint | Policy Attached | Connection Result                                                              | Granular Outbound Control                                         |
| -------- | ---------------- | --------------- | ------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| No       | No               | No              | Cannot Connect to Anything                                                     | N.A. as only private endpoints bypass firewall not svp            |
| No       | Yes              | No              | to test                                                                        | to test                                                           |
| Yes      | No               | No              | Can connect                                                                    | Granular control using fqdn rules; public endpoint of adls        |
| Yes      | Yes              | No              | Connect to all ADLS; using service endpoint accessible through firewall subnet | Since policy not attached to f/w subnet, we connects to both adls |
| Yes      | Yes              | Yes             | Granular connection to ADLS by using sep policy (assoc.w firewall subnet)      | Connected to ALLOWED ADLS, deny conncetion to DENIED ADLS         |
