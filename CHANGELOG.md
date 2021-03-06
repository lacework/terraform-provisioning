# DEPRECATION

This project has been deprecated. All modules developed in this repository have been migrated to separate github repositories, and are being published directly to the [Terraform Registry](https://registry.terraform.io/search/modules?q=lacework). This migration provides support for Terraform `0.13` and allows Lacework to release new features and fixes much faster!

---
# v0.2.1

## Features
* feat(azure): configure flexible subscription ids (#74) (Salim Afiune)([4b3e99b](https://github.com/lacework/terraform-provisioning/commit/4b3e99b2e7ddacafcf8b796698b8378e797056c4))
---
# v0.2.0

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
---
# v0.1.1

## Refactor
* refactor: modules azure config, activity_log and ad_application (#67) (Salim Afiune)([133de8a](https://github.com/lacework/terraform-provisioning/commit/133de8a9be3316f03df752458a74e54e4089148b))
## Bug Fixes
* fix(gcp): use correct Service Account Email (#65) (Salim Afiune)([d4777a1](https://github.com/lacework/terraform-provisioning/commit/d4777a19e9d155f30c7f23de985ca5b91e296723))
---
# v0.1.0

## Features
* feat: start versioning repo v0.1.0 (Salim Afiune Maya)([98dab7f](https://github.com/lacework/terraform-provisioning/commit/98dab7f384caa55056330ea629d5d4d368fb30c8))
* feat(aws): parameterize time_sleep duration with input wait_time (#62) (David Huang)([e7892c0](https://github.com/lacework/terraform-provisioning/commit/e7892c04336ee17e7da09bf57d79b64673581a75))
* feat(aws): add CloudTrail bucket security (Alan Nix)([4a8904f](https://github.com/lacework/terraform-provisioning/commit/4a8904fc24d6900ebb48f5032e360fa5a086014d))
* feat(aws): added CloudTrail bucket server-side encryption (Alan Nix)([cbb76b4](https://github.com/lacework/terraform-provisioning/commit/cbb76b4cfc54b948c4ff03d870516548569c414c))
* feat(aws): consolidated cloudtrail + multitenancy (#45) (Salim Afiune)([c099209](https://github.com/lacework/terraform-provisioning/commit/c0992091e59c6edfa025e31cebb715237db81451))
* feat: AWS Terraform Modules (#31) (Salim Afiune)([e307836](https://github.com/lacework/terraform-provisioning/commit/e30783677126f771a3bcc1f2fd1f706f54c488a1))
* feat(gcp): enable required APIs at project level (#27) (Andrew Wojszynski)([38009e5](https://github.com/lacework/terraform-provisioning/commit/38009e5647e7dd25590a32c1c98d425d75f1f68d))
* feat(aws): add cross_account_policy_name variable (Salim Afiune Maya)([7e5b158](https://github.com/lacework/terraform-provisioning/commit/7e5b158058562729065534c4bd3e3d50b8f5964a))
* feat(aws) Add CloudTrail Lacework Provider (Scott Ford)([456ae4a](https://github.com/lacework/terraform-provisioning/commit/456ae4a9cce0bb6db0ae5613967ee7701bb04397))
* feat(azure): use new lacework provider (Salim Afiune Maya)([b71fa39](https://github.com/lacework/terraform-provisioning/commit/b71fa39600a587b3ce54e09411734e4dda24f2d2))
* feat(gcp): use new lacework provider (Salim Afiune Maya)([47455a9](https://github.com/lacework/terraform-provisioning/commit/47455a9592d9fffaf7912cac7d29d1e7bcfba5cd))
* feat(aws): use new lacework provider (Salim Afiune Maya)([ecf0774](https://github.com/lacework/terraform-provisioning/commit/ecf0774747ca3da641f5b51feedd49ce6e4e4f6d))
* feat(AWS): Initial commit of aws template (Scott Ford)([cfb147d](https://github.com/lacework/terraform-provisioning/commit/cfb147da228a728408079d52c9569c47ea90ce7a))
## Refactor
* refactor(GCP): convert templates into TF Modules (#50) (Salim Afiune)([b938e9a](https://github.com/lacework/terraform-provisioning/commit/b938e9a8dad1a2eee6e4a3b30de12a4a455a110d))
## Bug Fixes
* fix(gcp): activate required apis correctly (#52) (Salim Afiune)([38b57ac](https://github.com/lacework/terraform-provisioning/commit/38b57ac6b687d4a12e6712d57dd565c6a791976c))
* fix(gcp): update depends_on 10s time sleep (Salim Afiune Maya)([c4307e5](https://github.com/lacework/terraform-provisioning/commit/c4307e5779d9408c260ecbb97d956439d441dcdd))
* fix(gcp): improve stability (#51) (Salim Afiune)([a860120](https://github.com/lacework/terraform-provisioning/commit/a8601201949405576fcf7640a5382d6b342b2fc1))
* fix(gcp): use correct resource_id for ORG or PROJ (#44) (Salim Afiune)([0c1dd84](https://github.com/lacework/terraform-provisioning/commit/0c1dd841a346d134d9531de1ec4469e5134adc22))
* fix(gcp): pass resource_level to LW integrations (#40) (Salim Afiune)([7665c2c](https://github.com/lacework/terraform-provisioning/commit/7665c2cfab07a5153247b8383b51f889349322ea))
* fix(aws): use SQS URL instead of ARN (Salim Afiune Maya)([2f84816](https://github.com/lacework/terraform-provisioning/commit/2f84816fa90b92b11551c91d4029e2305f51f8c6))
* fix: add dependencies to avoid tocken lockdown (Salim Afiune Maya)([084807e](https://github.com/lacework/terraform-provisioning/commit/084807e92315783b663cc37b9e4d1174d4ec99a8))
* fix(gcp): user project id inside output file (Salim Afiune Maya)([e6414b0](https://github.com/lacework/terraform-provisioning/commit/e6414b06c43c88b7206f0cd967dd07fbac9c4359))
* fix(aws): configure an External ID in IAM Role (Salim Afiune Maya)([572dc97](https://github.com/lacework/terraform-provisioning/commit/572dc97b6078481f4ce28925f26dfa268f8143a8))
* fix(var): display iam_role ARN instead of ID (Salim Afiune Maya)([354f0fb](https://github.com/lacework/terraform-provisioning/commit/354f0fb8471544eeaada1ab7e8744e987f98bd91))
* fix(review): remove tags variables + doc update (Salim Afiune Maya)([0765e1e](https://github.com/lacework/terraform-provisioning/commit/0765e1e7b6cb629f9e6f684d14724f5bed38bb21))
## Documentation Updates
* doc(azure): adds README.md (#36) (Salim Afiune)([00943d2](https://github.com/lacework/terraform-provisioning/commit/00943d2b341ec130cf14c7327b121199e16c3f58))
* docs(aws): Fixed typos and corrected main.tf example (#60) (Michael OConnor)([8784562](https://github.com/lacework/terraform-provisioning/commit/8784562e8b707f671e92981a2a765d06a8325683))
* docs(aws): added documentation for new 'bucket_sse_algorithm' variable (Alan Nix)([44bc6ff](https://github.com/lacework/terraform-provisioning/commit/44bc6ff7ef7c1b8808a07f0e1eb219f436fd36af))
* docs(aws): update README.md examples (#38) (Salim Afiune)([293c16e](https://github.com/lacework/terraform-provisioning/commit/293c16e7738e541b3b8abffcb15012f5b1ed3593))
* docs(README) Update AWS README for module refactor (#35) (Scott Ford)([8c086d0](https://github.com/lacework/terraform-provisioning/commit/8c086d013c1700b09c79542fd859e7172ce16a24))
* docs(gcp) Update README docs for Org and Project integration (#30) (Scott Ford)([15c3faa](https://github.com/lacework/terraform-provisioning/commit/15c3faa19a9da48232f03f53e7b860ba6624dd4a))
* docs(gcp): fix TF_VAR prefix in README.md (#28) (Salim Afiune)([44aad17](https://github.com/lacework/terraform-provisioning/commit/44aad1773c6c1d2464d24e7ae1760161b751c793))
* docs: add api keys env vars to README (#25) (Andrew Wojszynski)([dbac1ed](https://github.com/lacework/terraform-provisioning/commit/dbac1ed4590388833e75d1f71ce7108219c08094))
* docs: add step-by-step README.md for GCP (Scott Ford)([0092ca1](https://github.com/lacework/terraform-provisioning/commit/0092ca1236bc869d029b6d0da16b8d3d5cb6d5aa))
* docs(README): typos, links and format (Salim Afiune Maya)([542ffe7](https://github.com/lacework/terraform-provisioning/commit/542ffe7d46b56e6ea29d85276b3753647362be42))
* docs(README and LICENSE) Updates the main README and adds an apache2 LICENSE (Scott Ford)([b418897](https://github.com/lacework/terraform-provisioning/commit/b4188971955598f6d1f62f845d56e1fde3e8ba2a))
## Other Changes
* style: update aws and gcp templates (Salim Afiune Maya)([3222ed6](https://github.com/lacework/terraform-provisioning/commit/3222ed6bfb8b0fa48b608ff58f0dbb49c3ba650c))
* chore: fix all terraform fmt format (Salim Afiune Maya)([c375733](https://github.com/lacework/terraform-provisioning/commit/c375733fc7d62c29adb0ace5164d1b151d1c7dc3))
* chore: update Lacework's support website (#58) (Salim Afiune)([1ca6b58](https://github.com/lacework/terraform-provisioning/commit/1ca6b58c934c09ab75ee50bf03b1bc6cf0cd998c))
* chore(aws): expose cloudtrail SQS ARN (#48) (Salim Afiune)([f21d311](https://github.com/lacework/terraform-provisioning/commit/f21d311c6eac97fdd89e06956c49ee1fb530fe83))
* chore(aws): update typo in cloudtrail example (#46) (Salim Afiune)([ea52b87](https://github.com/lacework/terraform-provisioning/commit/ea52b878be7d48803a98d4d9c2705aea64c22c1d))
* chore(aws) rename enable_cloudtrail => use_existing_cloudtrail (#34) (Scott Ford)([1ab3036](https://github.com/lacework/terraform-provisioning/commit/1ab30365b8cacbaee5218b435357a16be6bc8ef4))
* ci: add badge and validate command (Salim Afiune Maya)([8f95e6c](https://github.com/lacework/terraform-provisioning/commit/8f95e6ce235f2c3ab598a1877988323dedcf9561))
* ci: add more integration test cases (Salim Afiune Maya)([4a72a50](https://github.com/lacework/terraform-provisioning/commit/4a72a50206c38e31a3713be092c3218e336e4646))
* ci: add fmt and integration tests (Salim Afiune Maya)([379891c](https://github.com/lacework/terraform-provisioning/commit/379891cb9101f4663ff514a21913604b1fea07bc))
* ci: enable circleci pipelines (Salim Afiune Maya)([e66ebd1](https://github.com/lacework/terraform-provisioning/commit/e66ebd1e1ace55d4505db93620beeb4cd429fba1))
