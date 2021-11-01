## Automated process to create Azure Databricks Workspace with data exfiltration protection.

Include:
1. Hub-Spoke networking with egress firewall to control all outbound traffic.
2. Private Link connection for backend traffic from data plane to control plane.
3. Private Link connection from user client to webapp service.
4. Private Link connection from data plane to dbfs storage.
5. (To Be Implemented) External Hive Metastore in your own subscription, with private endpoint connection.

Overall Architecture:
![alt text](https://github.com/hwang-db/tf_azure_deployment/blob/issue1/charts/Architecture.jpg?raw=true)


Module creates:
* Resource group with random prefix
* Tags, including `Owner`, which is taken from `az account show --query user`
* VNet with public and private subnet
* Databricks workspace

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr | n/a | `any` | n/a | yes |
| no\_public\_ip | n/a | `bool` | `false` | no |
| private\_subnet\_endpoints | n/a | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arm\_client\_id | n/a |
| arm\_subscription\_id | n/a |
| arm\_tenant\_id | n/a |
| azure\_region | n/a |
| databricks\_azure\_workspace\_resource\_id | n/a |
| test\_resource\_group | n/a |
| workspace\_url | n/a |

