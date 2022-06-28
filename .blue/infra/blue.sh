#!/bin/bash
##############################################################################
# Usage: ./blue.sh <up|down> <project_name> [environment_name] [location]
##############################################################################

set -e

projectName=${2}
environmentName="${3:-prod}"
location="${4:-westus2}"

showUsage() {
  echo "Usage: ./blue.sh <up|down> <project_name> [environment_name] [location]"
}

if [ -z "$projectName" ]; then
  showUsage
  echo "\nError: project name is required."
elif [ "$1" == "up" ]; then
  echo "Preparing environment '${environmentName}' of project '${projectName}'..."
  az deployment sub create \
    --template-file _index.bicep \
    --location $location \
    --parameters projectName=$projectName \
        environmentName=$environmentName \
        location=$location \
    --query properties.outputs
  echo "Environment '${environmentName}' of project '${projectName}' ready."
elif [ "$1" == "down" ]; then
  echo "Deleting environment '${environmentName}' of project '${projectName}'..."
  az group delete --yes --name "rg-${projectName}-${environmentName}"
  echo "Environment '${environmentName}' of project '${projectName}' deleted."
else
  showUsage
fi
