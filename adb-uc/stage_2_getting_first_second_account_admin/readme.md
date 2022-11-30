### Stage 2 Make AAD Global Admin SPN to be the first Databricks account admin

In this stage, we az login using SPN, and use this identity to hit the Databricks Provider Account Level endpoint to make the SPN the first account admin.
The stage 2 terraform scripts requires the AAD global admin SPN to authenticate to Databricks provider. 

Once this SPN becomes the first Databricks Account Admin, then this SPN can make other long lasting SPN as account admins, then you can remove the AAD Global Admin role.

log in via SPN:
`az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>`

Variable long_lasting_spn_id should be the client_id of a long lasting SPN.

```
provider "databricks" { // account level endpoint
  alias      = "azure_account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = "f3b0d159-720f-4d2e-bdc4-18104f13f419" // Databricks will provide
  auth_type  = "azure-cli"                            // az login with SPN
}
```
