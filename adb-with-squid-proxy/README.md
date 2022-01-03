# Objective of `adb-with-squid-proxy`:
1. Use packer to create azure image that functions as a squid proxy.
2. Use terraform to create vm / vmss, as squid proxy instance(s).
3. Deploy necessary networking infra.
4. Deploy Azure Databricks Workspace with all outbound traffic going through squid proxy, as such, we can achieve granular ACL control for outbound destinations.

Overall Architecture:
TO-DO

## Excution Steps:
1. Redirect to `/packer/tf_coldstart`, run:
   1. `terraform init`
   2. `terraform apply`
At this step 1, you will get a new rg and a local file in /packer/os.

2. Redirect to `/packer/os`, run:
   1. `packer build .`
At this step 2, packer will read the auto-generated `*auto.pkrvars.hcl` file and build the image.

3. Redirect to `/main`, run:
   1. `terraform init`
   2. `terraform apply`
At this step 3, in main terraform folder you will create all the resources for squid proxy.
