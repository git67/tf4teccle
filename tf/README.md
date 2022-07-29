# poc_tf_az

## The following steps are necessary:
#### - Install terrafom && azure-cli
#### - Check terraform && azure-cli

```
terraform version
az version
```

#### - Probe your azure secrets
```
ls ~/.azure
```

#### - List configured azure-cli account
```
az account list
```

#### - Probe connection to azure cloud
```
az account list-locations
```

#### - You have to pull the repository from github
```
git clone https://github.com/git67/poc_tf_az
```

#### - Initialize Terraform Backend (only once)
```
cd poc_tf_az/script

vi create_az_storage_4_tf.sh
...
# hs 01 / mw 02 / sl 03 
export TF_STATE_STORAGE_ACCOUNT=fitfstateacc01
export TF_STATE_STORAGE_CONTAINER=fitfstatestoragecontainer01
export KEYVAULT_NAME=fitfstatekeyvault01
export BACKEND_CONFIG=fi_tfstate_01
...

./create_az_storage_4_tf.sh

cd poc_tf_az/tf
. .env
init_backend_<hs|mw|sl>
```

