
Command
    az containerapp create : Create a Containerapp.

### WARNING: Command group 'containerapp' is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus

Arguments
    --name -n           [Required]
    --resource-group -g [Required] : Name of resource group. You can configure the default group
                                     using `az configure --defaults group=<name>`.
    --environment -e               : Name of the containerapp's environment.
    --location -l                  : Location. Values from: `az account list-locations`. You can
                                     configure the default location using `az configure --defaults
                                     location=<location>`.
    --no-wait                      : Do not wait for the long-running operation to finish.
    --tags                         : Space-separated tags: key[=value] [key[=value] ...]. Use '' to
                                     clear existing tags.
    --target-port
    --yaml                         : Path to a .yaml file with the configuration of a containerapp.
                                     All other parameters will be ignored.

Configuration Arguments
    --registry-login-server        : The url of the registry, e.g. myregistry.azurecr.io.
    --registry-password            : The password to log in container image registry server.
    --registry-username            : The username to log in container image registry server.
    --revisions-mode               : The active revisions mode for the containerapp.  Allowed
                                     values: multiple, single.
    --secrets -s                   : A list of secret(s) for the containerapp. Comma-separated
                                     values in 'key=value' format.

Container Arguments
    --args                         : A list of container startup command argument(s). Comma-
                                     separated values e.g. '-c, mycommand'. If there are multiple
                                     containers, please use --yaml instead.
    --command                      : A list of supported commands on the container app that will
                                     executed during container startup. Comma-separated values e.g.
                                     '/bin/queue'. If there are multiple containers, please use
                                     --yaml instead.
    --cpu                          : Required CPU in cores, e.g. 0.5.
    --environment-variables -v     : A list of environment variable(s) for the containerapp. Comma-
                                     separated values in 'key=value' format. If there are multiple
                                     containers, please use --yaml instead.
    --image -i                     : Container image, e.g. publisher/image-name:tag. If there are
                                     multiple containers, please use --yaml instead.
    --memory                       : Required memory, e.g. 250Mi.

Dapr Arguments
    --dapr-app-id                  : The dapr app id.
    --dapr-app-port                : The port of your app.
    --dapr-components              : The name of a yaml file containing a list of dapr components.
    --enable-dapr                  : Allowed values: false, true.

Ingress Arguments
    --ingress                      : Ingress type that allows either internal or external+internal
                                     ingress traffic to the Containerapp.  Allowed values: external,
                                     internal.
    --transport                    : The transport protocol used for ingress traffic.  Allowed
                                     values: auto, http, http2.  Default: auto.

Scale Arguments
    --max-replicas                 : The maximum number of containerapp replicas.
    --min-replicas                 : The minimum number of containerapp replicas.
    --scale-rules                  : The name of a yaml file containing a list of scale rules.

Global Arguments
    --debug                        : Increase logging verbosity to show all debug logs.
    --help -h                      : Show this help message and exit.
    --only-show-errors             : Only show errors, suppressing warnings.
    --output -o                    : Output format.  Allowed values: json, jsonc, none, table, tsv,
                                     yaml, yamlc.  Default: json.
    --query                        : JMESPath query string. See http://jmespath.org/ for more
                                     information and examples.
    --subscription                 : Name or ID of subscription. You can configure the default
                                     subscription using `az account set -s NAME_OR_ID`.
    --verbose                      : Increase logging verbosity. Use --debug for full debug logs.

Examples
    Create a Containerapp
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv


    Create a Containerapp with secrets and environment variables
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --secrets mysecret=escapefromtarkov,anothersecret=isadifficultgame
            --environment-variables myenvvar=foo,anotherenvvar=bar


    Create a Containerapp that only accepts internal traffic
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --ingress internal


    Create a Containerapp using an image from a private registry
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --secrets mypassword=verysecurepassword \
            --registry-login-server MyRegistryServerAddress \
            --registry-username MyUser \
            --registry-password mypassword


    Create a Containerapp with a specified startup command and arguments
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage  -e MyContainerappEnv \
            --command "/bin/sh"
            --args "-c", "while true; do echo hello; sleep 10;done"


    Create a Containerapp with a minimum resource and replica requirements
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --cpu 0.5 --memory 1.0Gi \
            --min-replicas 4 --max-replicas 8


    Create a Containerapp with scale rules
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --scale-rules PathToScaleRulesFile


    Create a Containerapp with dapr components
        az containerapp create -n MyContainerapp -g MyResourceGroup \
            --image MyContainerImage -e MyContainerappEnv \
            --enable-dapr --dapr-app-port myAppPort \
            --dapr-app-id myAppID \
            --dapr-components PathToDaprComponentsFile


To search AI knowledge base for examples, use: az find "az containerapp create"
