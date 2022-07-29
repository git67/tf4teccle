#!/bin/bash 

set -e

export AZ_LOCATION=germanywestcentral
export AZ_RG=RG_TF_SSH_KEYS

export KEY_FILE=~/.ssh/id_rsa.pub
export KEY_NAME=TF_PUB_KEY

# account vaildation
az account get-access-token --query "expiresOn" -o tsv

# create the resource group
echo "Creating ${AZ_RG} resource group..."
az group create -n ${AZ_RG} -l ${AZ_LOCATION}

echo "Resource group ${AZ_RG} created."

echo "Creating ${KEY_NAME} ssh key ..."
az sshkey create --location ${AZ_LOCATION} --public-key \@${KEY_FILE} --resource-group ${AZ_RG} --name ${KEY_NAME}
echo "SSH Key  ${KEY_NAME} created."
