#!/bin/bash
##############################################################################
# Usage: ./infra.sh <up|down> <project_name> [environment_name] [location]
# Creates or deletes an Azure infrastructure for a project.
##############################################################################

set -e

projectName=${2}
environment="${3:-prod}"
location="${4:-eastus2}"

showUsage() {
  echo "Usage: ./infra.sh <up|down> <project_name> [environment_name] [location]"
}

if [ -z "$projectName" ]; then
  showUsage
  echo "\nError: project name is required."
elif [ "$1" == "up" ]; then
  # echo "Retrieving current client ID..."
  # clientId=$(az ad signed-in-user show --query "id" --output tsv)
  echo "Preparing environment '${environment}' of project '${projectName}'..."
  az deployment sub create \
    --template-file _index.bicep \
    --name "deployment-${projectName}-${environment}-${location}" \
    --location $location \
    --parameters projectName=$projectName \
        environment=$environment \
        location=$location \
    --query properties.outputs
  echo "Environment '${environment}' of project '${projectName}' ready."
elif [ "$1" == "down" ]; then
  echo "Deleting environment '${environment}' of project '${projectName}'..."
  az group delete --yes --name "rg-${projectName}-${environment}"
  echo "Environment '${environment}' of project '${projectName}' deleted."
else
  showUsage
fi
