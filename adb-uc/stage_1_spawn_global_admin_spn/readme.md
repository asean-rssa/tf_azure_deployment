### Stage 1 Generate a Global Admin SPN

In stage 1, we use `az login` authentication with a **user principal** (you can also log in as a service principal) to generate a global admin SPN. The user principal / servicipal you use to authenticate with Stage 1 must be able to grant AAD Global Admin role to other users/SPNs.