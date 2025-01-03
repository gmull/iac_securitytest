# How to Deploy

## Deployment

### Setup Environment

Set enviroment variable settings

```bash
export RG_NAME="RG-EASTUS2-BICEP-TEST"
export AZURE_REGION="eastus2"
export VM_NAME="linux-vm1"
export ADMIN_USERNAME="local.admin"
export ADMIN_PASSWORD='Changeme123!#'
```

### Login

```bash
az login
```

STEP 2 - Select Subscription if prompted

### Create Azure Resource Group

```bash
az group create --name $RG_NAME --location $AZURE_REGION
```

### Deploy Template

*Syntax*
```bash
az deployment group create --resource-group <ResourceGroupName> --template-file vm-deploy.bicep --parameters vmName=<VMName> adminUsername=<AdminUser> adminPassword=<AdminPassword>
```

*Example*
```bash
az deployment group create --resource-group $RG_NAME --template-file vm-deploy.bicep --parameters vmName=$VM_NAME adminUsername=$ADMIN_USERNAME adminPassword=$ADMIN_PASSWORD
```
