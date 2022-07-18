#!/usr/bin/env bash

set -e

echo "-> Running the Lacework Cloud Shell startup script"

# Create a custom bin/ directory
mkdir -p $HOME/bin

# Install the Lacework CLI if it is not installed
if [ ! -f "$HOME/bin/lacework" ]; then
    echo "-> Installing the Lacework CLI..."
    curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash -s -- -d $HOME/bin
else
    echo "-> The Lacework CLI is already installed!"
    if [[ $(lacework version) == *"A newer version of the Lacework CLI is available"* ]]; then
        echo "-> Upgrading the Lacework CLI..."
        curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash -s -- -d $HOME/bin
    fi
fi

# Export required environment variables
if [ -z $PSModulePath ]; then
    echo "-> Setting up your Bash prompt..."
    lw_env="$HOME/.lw_env"
    echo 'export PATH="$HOME/bin:$PATH"' > $lw_env
    echo "source .lw_env" >> .bashrc
else
    echo "-> Setting up your Powershell prompt..."
    powershell_profile="$HOME/.config/PowerShell/Microsoft.PowerShell_profile.ps1"
    mkdir -p $HOME/.config/PowerShell/
    echo '$env:PATH="$env:HOME/bin:$env:PATH"' > $powershell_profile
fi

echo -n "-> Verifying that your user has the Global Administrator role... "
export USER_ID=$(az ad signed-in-user show --output=json | jq -r -M '.id')
export GLOBAL_ADMIN_ID=$(az rest --method get --url https://graph.microsoft.com/v1.0/directoryRoles | jq -r -M '.value[] | select(.displayName | contains("Global Administrator")) | .id')
export GLOBAL_ADMIN_MEMBER=$(az rest --method get --url https://graph.microsoft.com/v1.0/directoryRoles/${GLOBAL_ADMIN_ID}/members)

if [[ $GLOBAL_ADMIN_MEMBER == *"$USER_ID"* ]]; then
  echo "SUCCESS!"
else
  echo "Not Found!"
  echo ""
  echo "ERROR: You do NOT have the required role 'Global Administrator', the following people have it:"
  echo ""
  echo $GLOBAL_ADMIN_MEMBER | jq -r -M '.value[] | "  * \(.displayName) <\(.userPrincipalName)>"'
  exit 1
fi

echo "-> Verifying the Subscriptions that you have access to:"
export SUBSCRIPTION_ID=`az account show --output=json | jq -r -M '.id'`
echo ""
az account list --output table
echo ""
echo -n "-> Verifying that your user has the Owner role for the Subscriptions ID '$SUBSCRIPTION_ID'... "
export SUBSCRIPTION_ROLE=$(az role assignment list --all --assignee $USER_ID --subscription $SUBSCRIPTION_ID --output json --query '[].{id:principalId, name:roleDefinitionName}' | jq -r -M '.[] | select(.id | contains("'$USER_ID'")) | .name')
if [[ "$SUBSCRIPTION_ROLE" == *"Owner"* ]]; then
  echo "SUCCESS!"
  echo ""
  echo "-> IMPORTANT: All the resources will be created in your default Subscription '$SUBSCRIPTION_ID'."
  echo "              To switch to a different Subscription run the following command:"
  echo ""
  echo "              az account set --subscription [ID]"
else
  echo "Not Found!"
  echo ""
  echo "ERROR: You do NOT have the required role 'Owner' for the Subscription '$SUBSCRIPTION_ID'."
  echo "       The role found was '$SUBSCRIPTION_ROLE'. Try to switch to a different subscription."
  exit 1
fi

echo ""
echo "Your shell is almost ready. Type 'exit' then hit enter before running any Lacework CLI command. You will then be prompted to 'reconnect' to your shell"
