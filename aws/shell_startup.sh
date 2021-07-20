#!/usr/bin/env bash

set -e

echo "Setting up your Cloud Shell."

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

# Install Terraform if it is not installed
if [ ! -f "$HOME/bin/terraform" ]; then
    curl https://releases.hashicorp.com/terraform/0.14.4/terraform_0.14.4_linux_amd64.zip --output $HOME/bin/terraform.zip
    unzip $HOME/bin/terraform.zip -d $HOME/bin
    rm $HOME/bin/terraform.zip
fi

echo ""
echo "Your shell is ready."
