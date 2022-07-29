#!/bin/bash

set -e

export AZ_LOCATION=germanywestcentral
export AZ_RG=RG_TF_SSHKEY_STORAGE

export TF_SSHKEY_STORAGE_ACCOUNT=<name of tf sshkey storage account>
export TF_SSHKEY_STORAGE_CONTAINER=<name of tf sshkey storage container>
export KEYVAULT_NAME=<name of keyvault>
export TF_SSHKEY_SECRET_NAME=<name of sshkey secret>

# account vaildation
az account get-access-token --query "expiresOn" -o tsv

# Display information
echo "storage_account_name=${TF_SSHKEY_STORAGE_ACCOUNT}" 
echo "container_name=${TF_SSHKEY_STORAGE_CONTAINER}" 
echo "access_key=$(az keyvault secret show --name ${TF_SSHKEY_SECRET_NAME} --vault-name ${KEYVAULT_NAME} --query value -o tsv)"
