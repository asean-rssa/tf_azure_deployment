## Objective
1. Use packer to create azure image that have pre-installed Trino (previously prestosql) and configured to connect to Delta tables on ADLS Gen2, delta tables are created from Azure Databricks.
2. Use terraform to create vm as Trino vm instance, for testing and POC purposes, we only use 1 vm for Trino.
3. Deploy Azure Databricks Workspace and one notebook to create delta table on ADLS for Trino to query.
4. You need to use External Hive Metastore for your databricks cluster, and need to find a way to expose hive thrift service, one way to do is using HDI cluster, HDI - Azure Databricks sharing external hive metastore and you will have a thrift uri to be used in Trino server. At this stage, you have most of the major components ready and Trino configured, the only extra service required is an exposed hive service to Trino.

## Credits

Credits to Max (Wenjun.Zhou@microsoft.com) for creating the original solution and setting up trino-delta connector and Bowei (Bowei.Feng@microsoft.com) for efforts in overall solutioning.

## Overall Architecture:
<img src="../charts/trino-delta-connector.png" width="600">

Narratives: Databricks workspace is deployed into a VNet, the VNet has 3 subnets: 2 for databricks, 1 for Trino vm. We use Databricks to create external tables and put data on ADLS, and configure Trino to use delta connector to read delta tables. This folder currently has no hive services, and Trino setup is not complete. This can be completed in the future when there are actual requests on Trino-Delta connector projects. Project on hold for now. 

## Execution Steps:
### Step 1:

This step creates an `empty` resource group for hosting custom-built image and a local file of config variables in `/packer/os`.

Redirect to `/packer/tf_coldstart`, run:
   1. `terraform init`
   2. `terraform apply`

### Step 2:

This step you will use packer to build the actual trino image. Packer will read the auto-generated `*.auto.pkrvars.hcl` file and build the image. The image will have preconfigured to use Delta Connector.

Redirect to `/packer/os`, run:
   1. `packer build .`
   
### Step 3:

This step creates all the other infra for this project, specified in `/main`.

Redirect to `/main`, run:
   1. `terraform init`
   2. `terraform apply`

Now in folder of `/main`, you can find the auto-generated private key for ssh, to ssh into the provisioned vm, run:
`ssh -i ./ssh_private.pem azureuser@52.230.84.169`, change to the public ip of the trino vm accordingly. Check the nsg rules of the trino vm, we have inbound rule 300 allowing any source for ssh, this is for testing purpose only! 

### Step 4:

Open your databricks workspace, you will find a notebook been created in `Shared/` folder, this is the notebook to create delta tables with data stored on ADLS.

## Next steps (on hold for this folder)

Typically you should have hive service, and metastore uri starting with thrift://... to be used in Trino server delta.properties. We are not putting more details further due to time constraint. This can be prepared and completed at a future time with actual requests for POC etc.

## FAQ:

1. General Packer Token expired issue. Packer shows error: Status code 400, AADSTS700082 The refresh token has expired due to inactivity.
Solution -> packer usually stores token in user/.azure/packer, remove the tokens in that hidden folder and return to your packer project, do packer init and packer build again should resolve the issue.

![alt text](../charts/packer-issue.png?raw=true)