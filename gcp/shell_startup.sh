#!/usr/bin/env bash

set -e

echo "Setting up your Cloud Shell."

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

echo ""
echo "Your shell is almost ready. Type `exit` then hit enter before running any Lacework CLI command. Open the Cloud Shell again and the Lacework CLI will be ready for use!"
