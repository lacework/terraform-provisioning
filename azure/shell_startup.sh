#!/usr/bin/env bash

set -e

# Create a custom bin/ directory
mkdir -p $HOME/bin

# Install the Lacework CLI if it is not installed
if [ ! -f "$HOME/bin/lacework" ]; then
    curl https://raw.githubusercontent.com/lacework/go-sdk/master/cli/install.sh | bash -s -- -d $HOME/bin
fi

# Install Terraform if it is not installed
if [ ! -f "$HOME/bin/terraform" ]; then
    curl https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip --output $HOME/bin/terraform.zip
    unzip $HOME/bin/terraform.zip -d $HOME/bin
    rm $HOME/bin/terraform.zip
fi

# Export required Terraform environment variables
if [ -z $PSModulePath ]; then
    echo "Setting up your Bash prompt."
    lw_env="$HOME/.lw_env"
    echo 'export PATH="$HOME/bin:$PATH"' > $lw_env
    echo 'export ARM_SUBSCRIPTION_ID=$(az account show --output=json | jq -r -M ".id")' >> $lw_env
    echo 'export ARM_TENANT_ID=$(az account show --output=json | jq -r -M ".tenantId")' >> $lw_env
    echo 'export ARM_USE_MSI=true' >> $lw_env
    echo "source .lw_env" >> .bashrc
else
    echo "Setting up your Powershell prompt."
    powershell_profile="$HOME/.config/PowerShell/Microsoft.PowerShell_profile.ps1"
    mkdir -p $HOME/.config/PowerShell/
    echo '$env:PATH="$env:HOME/bin:$env:PATH"' > $powershell_profile
    echo '$env:ARM_SUBSCRIPTION_ID=az account show --output=json | jq -r -M ".id"' >> $powershell_profile
    echo '$env:ARM_TENANT_ID=az account show --output=json | jq -r -M ".tenantId"' >> $powershell_profile
    echo '$env:ARM_USE_MSI="true"' >> $powershell_profile
fi

echo ""
echo "Your shell is almost ready. Type 'exit' then hit enter before running any Lacework CLI command. You will then be prompted to 'reconnect' to your shell"
