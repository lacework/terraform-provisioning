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

# Tag:tf-go-integration
FROM golang:1.16 AS tf-go-integrations
RUN apt-get update && apt-get install -y gnupg software-properties-common curl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install terraform

# Tag:ally-releases
FROM techallylw/tf-go-integrations AS ally-releases
RUN apt-get update && apt-get install -y jq zip
