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
