# ADB workspace with external hive metastore

This template creates:
1. SQL Server
2. SQL database
3. ADB workspace

Overall Architecture:
![alt text](../charts/adb-external-hive-metastore.png?raw=true)

Prepare the environment variables: terraform will automatically look for environment variables with name format TF_VAR_xxxxx.
In our local environment, use:
`export TF_VAR_db_username=yoursqlserveradminuser`
and `export TF_VAR_db_password=yoursqlserveradminpassword`