# ADB workspace with squid proxy

Having a proxy server will:
1. Bring in the cache layer.
2. Access Control List - ACL to control outbound traffic destination at fine level.
3. ACL configs are stored in textfile, easy to manage / update.
4. Bypass internet filtering.

2 ways to configure proxy server:
3128 default port for squid proxxy server.
transparent proy server: proxxy behaves like default gateway, transparent to users.


`sudo apt-get update`
`sudo vim /etc/squid/squid.conf`
# check status of job
`service squid status`

`squid.conf` looks very long and tedious.
Most config files are just instructions.

sudo apt-get update
sudo vim /etc/squid/squid.conf

# check status of job
service squid status

acl allowed_sites dstdomain .dbartifactsprodseap.blob.core.windows.net
acl allowed_sites dstdomain .dbartifactsprodeap.blob.core.windows.net
acl allowed_sites dstdomain .dblogprodseasia.blob.core.windows.net
acl allowed_sites dstdomain .prod-southeastasia-observabilityeventhubs.servicebus.windows.net
acl allowed_sites dstdomain .cdnjs.com
acl allowed_sites dstdomain .dbfsj89k8n.blob.core.windows.net

`sudo service squid restart` to restart squid and make conf effective.

https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows
First to generate ssh keypair
`ssh-keygen -m PEM -t rsa -b 4096`

Your outbound traffic from Data Plane of Databricks, will be controlled by firewall rules; in addition, you can enforce granular access control to specific storage account, using service endpoint policy attached to firewall subnet. Traffic to storage accounts will be through service endpoints.

You need to add storage accounts into firewall FQDN rules. Then to associate a service endpoint policy to firewall subnet to allow granular egress control.

## Scenario:
Given 2 storage accounts: 
1. randomallowedstorage
2. randomdeniedstorage
   
We configured in service endpoint policy to allow access to randomallowedstorage only.

## Definitions:
`Firewall: if we have FQDN rules to allow connection to ADLS.`

`Service Endpoint: if we have enabled service endpoint on f/w subnet.`

`Policy Attached: if a sep policy will be attached to f/w subnet.`

## Getting Started
1. Clone this repo to your local machine.
2. Run `terraform init` to initialize terraform and get provider ready.
3. Change `terraform.tfvars` values to your own values.
4. Inside the local project folder, run `terraform apply` to create the resources.