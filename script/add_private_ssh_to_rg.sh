#!/bin/bash 

set -e

export AZ_LOCATION=germanywestcentral
export AZ_RG=RG_TF_SSH_KEYS

export KEY_FILE=~/.ssh/id_rsa
export VAULT_NAME=TF-PRIV-KEY
export KEY_NAME=private-key01

# account vaildation
az account get-access-token --query "expiresOn" -o tsv


echo "Creating ${VAULT_NAME} key vault ..."
az keyvault create --name ${VAULT_NAME} --resource-group ${AZ_RG} --output table
echo "Key Vault  ${VAULT_NAME} created."


echo "Adding private Key to Vault ${VAULT_NAME} ..."
az keyvault secret set --vault-name ${VAULT_NAME}  --name ${KEY_NAME} --value @${KEY_FILE}
