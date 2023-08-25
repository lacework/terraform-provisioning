# This images is used to test our Terraform Provider and Modules
#
# Repo: techallylw/terraform
# URL: https://hub.docker.com/r/techallylw/terraform

# Tag: 12
FROM hashicorp/terraform:0.12.31 AS terraform12
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag: 13
FROM hashicorp/terraform:0.13.7 AS terraform13
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag: 14
FROM hashicorp/terraform:0.14.11 AS terraform14
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag: 15
FROM hashicorp/terraform:0.15.3 AS terraform15
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag: 1.0
FROM hashicorp/terraform:1.0.0 AS terraform1.0
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag: 1.1
FROM hashicorp/terraform:1.1.9 AS terraform1.1
RUN apk update
RUN apk add bash
RUN apk add curl
RUN apk add make jq

# Tag:tf-go-integration
FROM golang:1.21.0 AS tf-go-integrations
RUN apt-get update && apt-get install -y gnupg software-properties-common curl
RUN apt-get update && apt-get install -y jq zip
RUN apt-get update && apt-get install -y gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update
RUN apt-get install terraform

# Tag:ally-releases
FROM techallylw/tf-go-integrations AS ally-releases
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

