<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# Lacework Provisioning with Terraform

[![lacework](https://circleci.com/gh/lacework/terraform-provisioning.svg?style=shield)](https://circleci.com/gh/lacework/terraform-provisioning)

This repository contains [Terraform](https://terraform.io) code for provisioning resources
required to integrate public cloud environments (AWS, GCP, Azure) into Lacework's automated
security platform.

For more information visit [support.lacework.com](https://support.lacework.com/).

## Requirements
- [Terraform](https://terraform.io) 0.12.x

## Public Cloud Support
This repository currently supports provisioning of required resources in the following Public Cloud Providers:

- [AWS](aws/)
- [Google Cloud](gcp/)
- [Azure](azure/)

Please refer to the `README` for specific documentation and usage.

## Reporting Issues

Issues can be reported by using [GitHub Issues](https://github.com/lacework/terraform-provisioning/issues).

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
