### Stage 1: Generate a Global Admin SPN

In stage 1, we use `az login` authentication with a user principal (you can also log in as a service principal) to generate a global admin SPN. This SPN will be used to create the other SPNs in the next stage.
