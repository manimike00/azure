# Installations:

### Add extensions
```
	az extension add --source https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl
```

### Add Provider
```
	az provider register --namespace Microsoft.Web
```

## Group
```
  az containerapp : Commands to manage Containerapps.
```		
#### WARNING: This command group is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus

## Subgroups:
```
    env           : Commands to manage Containerapps environments.
    github-action
    revision      : Commands to manage a Containerapp's revision.
```		

## Commands:
```
    create        : Create a Containerapp.
    delete        : Delete a Containerapp.
    list          : List Containerapps.
    scale
    show          : Show details of a Containerapp.
    update        : Update a Containerapp.
```
#### To search AI knowledge base for examples, use: az find "az containerapp"
