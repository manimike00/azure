# Deploy azure kubernetes service (AKS)

### Create terraform.tfvars file
```agsl
touch terraform.tfvars
```

### Add the values for the variables
```agsl
# general varaiables
name     = "demo"
env      = "dev"
project  = "rapyder"
location = "centralindia"

# virtual network
address_space               = "10.11.0.0/16"
address_prefixes_default_np = "10.11.1.0/24"

# service principle
subscription_id = "xxxx-yyyy-zzzz"
client_id       = "xxxx-yyyy-zzzz"
client_secret   = "xxxx-yyyy-zzzz"
tenant_id       = "xxxx-yyyy-zzzz"
```

### Initialise terraform
```agsl
terraform init
```

### Plan and deploy resources
```agsl
terraform plan
terraform apply --auto-approve
```

## NOTE:
```agsl
1. Terraform Statefiles is stored in local machine
2. Dont commit terrraform.tfvars with service principle credentials
```


## References
[AKS best practice - backing up aks with velero](https://gaunacode.com/aks-best-practice-backing-up-aks-with-velero)