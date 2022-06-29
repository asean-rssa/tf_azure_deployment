# Terraform patterns for Azure Databricks deployments

Subdirectories are independent to each other, each represents a Terraform pattern of Azure Databricks workspace deployment.

Azure Databricks deployment patterns:
1. `adb-exfiltration-protection`, classic hub-spoke firewall setup for blog: https://databricks.com/blog/2020/03/27/data-exfiltration-protection-with-azure-databricks.html.
2. `adb-external-hive-metastore`, Azure Databricks workspace with private endpoint connection to external hive metastore.
3. `adb-private-links`, Azure Databricks workspace with multiple private links and firewall: Data Plane - Control Plane PL, Data Plane - DBFS PL.
4. `adb-with-squid-proxy`, Azure Databricks workspace, with squid proxy to filter outbound traffic, decoupling data exfiltration costs from data volume.
5. `adb-service-endpoint-policy-experiment`, an experimental setup with service endpoint policy, this setup is just for reference and trial using SEP. Granular egress outbound control through SEP is not directly supported.
6. `adb-trino-delta-connector`, a POC setup to show Trino-Delta Connector. 
7. `adb-splunk`, a POC setup to show Splunk-Databricks connector, referring to https://github.com/databrickslabs/splunk-integration.