### Stage 2

Authenticate to TF providers using the AAD global admin SPN. 
Hit the Databricks Provider Account Level provider and this SPN becomes the first Databricks account admin.

Then this SPN can make other long lasting SPN as account admin. 
Databricks Account level auth using az cli auth, log in via SPN:
`az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>`
