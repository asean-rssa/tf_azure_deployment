### Stage 3 SPN deploys UC resources

In this stage, we use an ordinary SPN to deploy UC resouces. The SPN has been granted Account Admin role such that it can deploy UC metastores. 
This SPN does not require AAD Global Admin role.

`az login --service-principal xxx` log in as SPN.