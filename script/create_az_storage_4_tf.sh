#!/bin/bash

set -e

export AZ_LOCATION=germanywestcentral
export AZ_RG=RG_TF_STATE_STORAGE

export TF_STATE_STORAGE_ACCOUNT=<name of state storage account>
export TF_STATE_STORAGE_CONTAINER=<name of state storage container>
export KEYVAULT_NAME=<name of keyvault>
export BACKEND_CONFIG=<name of backend config>

# account vaildation
az account get-access-token --query "expiresOn" -o tsv

# create the resource group
echo "Creating ${AZ_RG} resource group..."
az group create -n ${AZ_RG} -l ${AZ_LOCATION}

echo "Resource group ${AZ_RG} created."

# Create the storage account
echo "Creating ${TF_STATE_STORAGE_ACCOUNT} storage account..."
az storage account create -g ${AZ_RG} -l ${AZ_LOCATION} \
  --name ${TF_STATE_STORAGE_ACCOUNT} \
  --sku Standard_LRS \
  --encryption-services blob

echo "Storage account ${TF_STATE_STORAGE_ACCOUNT} created."

# Retrieve the storage account key
echo "Retrieving storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group ${AZ_RG} --account-name ${TF_STATE_STORAGE_ACCOUNT} --query [0].value -o tsv)
echo ${ACCOUNT_KEY}
echo "Storage account key retrieved."

# Create a storage container (for the Terraform State)
echo "Creating ${TF_STATE_STORAGE_CONTAINER} storage container..."
az storage container create --name ${TF_STATE_STORAGE_CONTAINER} --account-name ${TF_STATE_STORAGE_ACCOUNT} --account-key ${ACCOUNT_KEY}

echo "Storage container ${TF_STATE_STORAGE_CONTAINER} created."

# Create an Azure KeyVault
echo "Creating ${KEYVAULT_NAME} key vault..."
az keyvault create -g ${AZ_RG} -l ${AZ_LOCATION} --name ${KEYVAULT_NAME}

echo "Key vault ${KEYVAULT_NAME} created."

# Store the Terraform State Storage Key into KeyVault
echo "Store storage access key into key vault secret..."
az keyvault secret set --name tfstate-storage-key --value ${ACCOUNT_KEY} --vault-name ${KEYVAULT_NAME}

echo "Key vault secret created."

# Display information
echo "Azure Storage Account and KeyVault have been created."
echo "Run the following command to initialize Terraform to store its state into Azure Storage:"
echo "terraform init -backend-config=\"storage_account_name=${TF_STATE_STORAGE_ACCOUNT}\" -backend-config=\"container_name=${TF_STATE_STORAGE_CONTAINER}\" -backend-config=\"access_key=\$(az keyvault secret show --name tfstate-storage-key --vault-name ${KEYVAULT_NAME} --query value -o tsv)\" -backend-config=\"key=${BACKEND_CONFIG}\""
