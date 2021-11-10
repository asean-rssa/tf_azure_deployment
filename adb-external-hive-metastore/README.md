# ADB workspace with external hive metastore

This template creates:
1. SQL Server
2. SQL database
3. ADB workspace


Before driver and executor JVM is ready on cluster, we specify in the Init script for cluster to download all the required jars. 

Overall Architecture:
![alt text](../charts/adb-external-hive-metastore.png?raw=true)

# Get Started:
On your local machine, inside this folder of `adb-external-hive-metastore`:
Prepare the environment variables: terraform will automatically look for environment variables with name format TF_VAR_xxxxx.
In our local environment, set:
`export TF_VAR_db_username=yoursqlserveradminuser`
and `export TF_VAR_db_password=yoursqlserveradminpassword`

`terraform init`
`terraform apply`

It will deploy 99% steps for you automatically. The 1% is the last step, to manually trigger a run of job to initialize schema of database.
After the deployment, go to databricks workspace - Job - run the auto-deployed job only once; this is to initialize the database with metastore schema.
![alt text](../charts/manual_last_step.png?raw=true)
Then you can verify in a notebook:
![alt text](../charts/test_metastore.png?raw=true)
We can also check inside the sql db (metastore):
![alt text](../charts/metastore_content.png?raw=true)


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
