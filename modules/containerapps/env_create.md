
## Command
```
    az containerapp env create : Create a Containerapp environment.
```

#### WARNING: Command group 'containerapp env' is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus

## Arguments
```
    --logs-workspace-id    [Required]
    --logs-workspace-key   [Required]
    --name -n              [Required]
    --resource-group -g    [Required] : Name of resource group. You can configure the default group
                                        using `az configure --defaults group=<name>`.
    --app-subnet-resource-id          : Resource ID of a subnet that Container App containers are
                                        injected into. This subnet must be in the same VNET as the
                                        subnet defined in controlPlaneSubnetResourceId.
    --controlplane-subnet-resource-id : Resource ID of a subnet for control plane infrastructure
                                        components. This subnet must be in the same VNET as the
                                        subnet defined in appSubnetResourceId.
    --instrumentation-key
    --location -l                     : Location of resource. Examples: Canada Central, North
                                        Europe.
    --logs-dest                       : Default: log-analytics.
    --no-wait                         : Do not wait for the long-running operation to finish.
    --tags                            : Space-separated tags: key[=value] [key[=value] ...]. Use ''
                                        to clear existing tags.
```                                        
## Global Arguments
```
    --debug                           : Increase logging verbosity to show all debug logs.
    --help -h                         : Show this help message and exit.
    --only-show-errors                : Only show errors, suppressing warnings.
    --output -o                       : Output format.  Allowed values: json, jsonc, none, table,
                                        tsv, yaml, yamlc.  Default: json.
    --query                           : JMESPath query string. See http://jmespath.org/ for more
                                        information and examples.
    --subscription                    : Name or ID of subscription. You can configure the default
                                        subscription using `az account set -s NAME_OR_ID`.
    --verbose                         : Increase logging verbosity. Use --debug for full debug logs.
```    

## Examples
```
    Create a Containerapp Environment.
        az containerapp env create -n MyContainerappEnvironment -g MyResourceGroup \
            --logs-workspace-id myLogsWorkspaceID \
            --logs-workspace-key myLogsWorkspaceKey \
            --location Canada Central
```            

#### To search AI knowledge base for examples, use: az find "az containerapp env create"
