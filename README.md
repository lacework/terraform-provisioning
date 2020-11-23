<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# DEPRECATED - Lacework Provisioning with Terraform

[![GitHub release](https://img.shields.io/github/release/lacework/terraform-provisioning.svg)](https://github.com/lacework/terraform-provisioning/releases/)
[![CircleCI status](https://circleci.com/gh/lacework/terraform-provisioning.svg?style=shield)](https://circleci.com/gh/lacework/terraform-provisioning)

## **WARNING - THIS PROJECT IS BEING DEPRECATED**

This project is being deprecated. All modules developed in this repository have been migrated to separate github repositories, and are being published directly to the [Terraform Registry](https://registry.terraform.io/search/modules?q=lacework). This migration provides support for Terraform `0.13` and allows Lacework to release new features and fixes much faster!

### New Project Locations
* **AWS**
    * `iam-role` - [Terraform Registry](https://registry.terraform.io/modules/lacework/iam-role/aws/latest) | [Github](github.com/lacework/terraform-aws-iam-role )
    * `config`- [Terraform Registry](https://registry.terraform.io/modules/lacework/config/aws/latest) | [Github](github.com/lacework/terraform-aws-config)
    * `cloudtrail` - [Terraform Registry](https://registry.terraform.io/modules/lacework/cloudtrail/aws/latest) | [Github](https://github.com/lacework/terraform-aws-cloudtrail)
* **Google Cloud**
    * `service-account` - [Terraform Registry](https://registry.terraform.io/modules/lacework/service-account/gcp/latest) | [Github](https://github.com/lacework/terraform-gcp-service-account)
    * `config`- [Terraform Registry](https://registry.terraform.io/modules/lacework/config/gcp/latest) | [Github](https://github.com/lacework/terraform-gcp-config)
    * `audit-log` - [Terraform Registry](https://registry.terraform.io/modules/lacework/audit-log/gcp/latest) | [Github](https://github.com/lacework/terraform-gcp-audit-log)
* **Azure**
    * `ad-application` - [Terraform Registry](https://registry.terraform.io/modules/lacework/ad-application/azure/latest) **|** [Github](https://github.com/lacework/terraform-azure-ad-application)
    * `config`- [Terraform Registry](https://registry.terraform.io/modules/lacework/config/azure/latest) **|** [Github](https://github.com/lacework/terraform-azure-config)
    * `activity-log` - [Terraform Registry](https://registry.terraform.io/modules/lacework/activity-log/azure/latest) **|** [Github](https://github.com/lacework/terraform-azure-activity-log)


## New Lacework Documentation

For documentation on using Lacework Terraform modules, see the new Terraform documentation on [support.lacework.com](https://support.lacework.com/hc/en-us/search?utf8=%E2%9C%93&query=terraform)



## License and Copyright
Copyright 2020, Lacework Inc.
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
