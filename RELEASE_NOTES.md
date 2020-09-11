# Release Notes
Another day, another release. These are the release notes for the version `v0.2.0`.

# Breaking Changes

### Users now MUST provide ARN for IAM Role and/or S3 bucket

If you are using one of the `use_existing_iam_role` or `use_existing_cloudtrail` variables,
you will have to update your Terraform plans to pass not only the name but the ARN as well.

### Existing IAM Role
**Before:**
```hcl
provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"

	# Use an existing IAM role
	use_existing_iam_role = true
	iam_role_name         = "lw-existing-role"
	iam_role_external_id  = "1GrDkEZV5VJ@=nLm"
}
```
**Now:**
```hcl
provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"

	# Use an existing IAM role
	use_existing_iam_role = true
	iam_role_arn          = "arn:aws:iam::123456789012:role/lw-existing-role"  // <-- NEW! Must be provided
	iam_role_name         = "lw-existing-role"
	iam_role_external_id  = "1GrDkEZV5VJ@=nLm"
}
```

### Existing CloudTrail
**Before:**
```hcl
provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"

	# Use an existing CloudTrail
	use_existing_cloudtrail    = true
	bucket_name                = "lacework-ct-bucket-8805c0bf"
	sns_topic_name             = "lacework-ct-sns-8805c0bf"
}
```
**Now:**
```hcl
provider "lacework" { }

provider "aws" { }

module "aws_cloudtrail" {
	source = "git::https://github.com/lacework/terraform-provisioning.git//aws/modules/cloudtrail?ref=master"

	# Use an existing CloudTrail
	use_existing_cloudtrail    = true
	bucket_arn                 = "arn:aws:s3:::lacework-ct-bucket-8805c0bf"  // <-- NEW! Must be provided
	bucket_name                = "lacework-ct-bucket-8805c0bf"
	sns_topic_name             = "lacework-ct-sns-8805c0bf"
}
```

## Refactor
* refactor(aws): avoid using s3_bucket data source (Salim Afiune Maya)([ced2190](https://github.com/lacework/terraform-provisioning/commit/ced21905f9227b945a929aee6baf0d8138589e6e))
* refactor(aws): avoid using iam_role data source (Salim Afiune Maya)([c2a7a7f](https://github.com/lacework/terraform-provisioning/commit/c2a7a7f222d2650f9de4c7756f14fa04fbe99a32))
## Bug Fixes
* fix(azure): typo inside output.tf (#72) (Salim Afiune)([65b4f84](https://github.com/lacework/terraform-provisioning/commit/65b4f848726152f07bc29c2cbbd88cf4bf3cda20))
* fix(azure): use object id instead of principal id (#71) (Salim Afiune)([78d7dd1](https://github.com/lacework/terraform-provisioning/commit/78d7dd197017d20b2ed8a6dadc7ee7190fc492fd))
* fix(gcp): for project level integrations (#69) (Salim Afiune)([af9c35e](https://github.com/lacework/terraform-provisioning/commit/af9c35eb01f4126bd4cb6cf798f9531423ca10ec))
## Documentation Updates
* doc(aws): update aws/README.md (Salim Afiune Maya)([d15660f](https://github.com/lacework/terraform-provisioning/commit/d15660f078ffb6f7ea0e4d8778021ac028bd536b))
## Other Changes
* ci: update tests from modified examples/ (Salim Afiune Maya)([31e012d](https://github.com/lacework/terraform-provisioning/commit/31e012dc8e00f7c84836bb691ba67b16ab0af0b8))
