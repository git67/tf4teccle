## terraform

#### - You need a well working azure cli in your environment and existing azure credentials
```
  https://docs.microsoft.com/de-de/cli/azure/install-azure-cli-linux?pivots=apt
```

#### - You have to pull these repository
```
git clone --branch feature/example_azure https://github.com/git67/tf4teccle.git ./example_azure
cd ./example_azure
```

###### - Place your own variablenames into shell stuff in ./script
```
...
  script/create_az_storage_4_tf.sh:export TF_STATE_STORAGE_ACCOUNT=<name of state storage account>
  script/create_az_storage_4_tf.sh:export TF_STATE_STORAGE_CONTAINER=<name of state storage container>
  script/create_az_storage_4_tf.sh:export KEYVAULT_NAME=<name of keyvault>
  script/create_az_storage_4_tf.sh:export BACKEND_CONFIG=<name of backend config>
  script/print_az_storage_4_sshkeys.sh:export TF_SSHKEY_STORAGE_ACCOUNT=<name of tf sshkey storage account>
  script/print_az_storage_4_sshkeys.sh:export TF_SSHKEY_STORAGE_CONTAINER=<name of tf sshkey storage container>
  script/print_az_storage_4_sshkeys.sh:export KEYVAULT_NAME=<name of keyvault>
  script/print_az_storage_4_sshkeys.sh:export TF_SSHKEY_SECRET_NAME=<name of sshkey secret>
...
```

###### - Place your subscription_id and tenant_id into ./tf/main.tf
```
...
  subscription_id = var.az_creds["subscription_id"]
  tenant_id       = var.az_creds["tenant_id"]
...
```

#### - Initialisation of terraform environment
```
cd .tf/
terraform init
```

#### - Probe your terraform code
```
terraform validate
terraform plan
```

#### - Run terraform without any interaction
```
terraform apply -auto-approve
```

#### - Remove your deployment
```
terraform destroy -auto-approve
```

