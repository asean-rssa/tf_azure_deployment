# On-prem Git Servers (Github Enterpise Onprem, Bitbucket Server etc.) with Azure Databricks

```
This is an automated terraform template to deploy Databricks workspace and a single-node cluster that will relay control plane git traffic to on-prem git server.
```

From the official doc on ADB repos: https://docs.microsoft.com/en-us/azure/databricks/repos/, there's no direct support for on-prem git servers. This is because git operations are initiated from the control plane (think about the moment you push from UI); and the Databricks control plane does not have direct connection to your onprem git server. 

As of 202208, the long-term private link based solution for onprem git servers is still in development; for the near future, we only have this git proxy based solution for onprem git servers; this terraform pattern is the adaption from the work of hj.suh@databricks.com, and serves as the reference implementation of git proxy.

```
See the original git proxy work from https://gist.github.com/hjsuh18/4805b5c3dfe3aa1bbabc250a98cb89a2
```

## Overall Architecture

