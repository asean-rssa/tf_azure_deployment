# Objective of `adb-with-squid-proxy`:
1. Use packer to create azure image that functions as a squid proxy.
2. Use terraform to create vm / vmss, as squid proxy instance(s).
3. Deploy necessary networking infra.
4. Deploy Azure Databricks Workspace with all outbound traffic going through squid proxy, as such, we can achieve granular ACL control for outbound destinations.

Overall Architecture:
TO-DO

## Logic:
1. prepare for cold start, create rg for image.
2. 

## Getting Started
1. Clone this repo to your local machine.
2. Run `terraform init` to initialize terraform and get provider ready.
3. Change `terraform.tfvars` values to your own values.
4. Inside the local project folder, run `terraform apply` to create the resources.



1. In folder /packer/os, run 'packer build .'