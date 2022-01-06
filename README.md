# Terraform patterns for Azure Databricks deployments

Folders are independent to each other, each represents a Terraform pattern on Azure Databricks. You are also encouraged to mix and match based on your environmental requirements.

This repo includes:
1. Azure Databricks workspace, with external hive metastore.
2. Azure Databricks workspace, with multiple private links: Data Plane - Control Plane PL, Data Plane - DBFS PL.
3. Azure Databricks workspace, with squid proxy to filter outbound traffic, decoupling data exfiltration costs from data volume.