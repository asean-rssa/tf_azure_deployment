# ADB workspace with external hive metastore

This template creates:
1. SQL Server
2. SQL database
3. ADB workspace

Overall Architecture:
![alt text](../charts/adb-external-hive-metastore.png?raw=true)

Prepare the environment variables: terraform will automatically look for environment variables with name format TF_VAR_xxxxx.
In our local environment, set:
`export TF_VAR_db_username=yoursqlserveradminuser`
and `export TF_VAR_db_password=yoursqlserveradminpassword`

## Inputs

| Name             | Description               | Type     | Default         |  Required  |
| ---------------- | ------------------------- | -------- | --------------- | :--------: |
| spokecidr        | n/a                       | `string` | "10.179.0.0/20" |    yes     |
| sqlvnetcidr      | n/a                       | `string` | "10.178.0.0/20" |    yes     |
| no\_public\_ip   | n/a                       | `bool`   | `true`          |    yes     |
| rglocation       | n/a                       | `string` | "southeastasia" |    yes     |
| dbfs_prefix      | n/a                       | `string` | "dbfs"          |    yes     |
| workspace_prefix | n/a                       | `string` | "adb"           |    yes     |
| db_username      | sql server admin username | `string` | n/a             | as env var |
| db_password      | sql server admin password | `string` | n/a             | as env var |


## Outputs

| Name                                       | Description |
| ------------------------------------------ | ----------- |
| arm\_client\_id                            | n/a         |
| arm\_subscription\_id                      | n/a         |
| arm\_tenant\_id                            | n/a         |
| azure\_region                              | n/a         |
| databricks\_azure\_workspace\_resource\_id | n/a         |
| resource\_group                            | n/a         |
| workspace\_url                             | n/a         |
