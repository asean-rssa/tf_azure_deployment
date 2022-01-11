# Objective
1. Use packer to create azure image that functions as a squid proxy.
2. Use terraform to create vm / vmss, as squid proxy instance(s).
3. Deploy necessary networking infra.
4. Deploy Azure Databricks Workspace with all outbound traffic going through squid proxy, as such, we can achieve granular ACL control for outbound destinations.

## Overall Architecture:
![alt text](../charts/adb-squid-proxy.png?raw=true)

Narratives: Databricks workspace 1 is deployed into a VNet, which is peered to another VNet hosting a single Squid proxy server, every databricks spark cluster will be configured using init script to direct traffic to this Squid server. We control ACL in squid.conf, such that we can allow/deny traffic to certain outbound destinations. 

Does this apply to azure services as well (that goes through azure backbone network)


## Excution Steps:
Step 1, you will create a new rg and a local file in `/packer/os`.

1. Redirect to `/packer/tf_coldstart`, run:
   1. `terraform init`
   2. `terraform apply`

Step 2, packer will read the auto-generated `*auto.pkrvars.hcl` file and build the image.

2. Redirect to `/packer/os`, run:
   1. `packer build .`
   
Step 3, in main terraform folder you will create all the resources for squid proxy.

3. Redirect to `/main`, run:
   1. `terraform init`
   2. `terraform apply`

Now in folder of `/main`, you can find the auto-generated private key for ssh, to ssh into the provisioned vm, run:
`ssh -i ./ssh_private.pem azureuser@52.230.84.169`
Change to your vm's public ip accordingly.