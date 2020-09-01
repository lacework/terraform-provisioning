#!/bin/bash
#
# Name::        ci_tests.sh
# Description:: Use this script to run ci tests of this repository
# Author::      Salim Afiune Maya (<afiune@lacework.net>)
#
set -eou pipefail

readonly project_name=terraform-provisioning

MODULES=(
  aws/
  aws/modules/iam_role
  aws/modules/config
  aws/modules/cloudtrail
  gcp/
  gcp/modules/audit_log
  gcp/modules/config
  gcp/modules/service_account
)

TEST_CASES=(
  aws/
  aws/modules/iam_role/examples/default-config
  aws/modules/iam_role/examples/custom-config
  aws/modules/config/examples/custom-config
  aws/modules/config/examples/default-config
  aws/modules/cloudtrail/examples/complete-cloudtrail
  aws/modules/cloudtrail/examples/consolidated-cloudtrail-multiple-lacework-tenants
  aws/modules/cloudtrail/examples/consolidated-cloudtrail
  aws/modules/cloudtrail/examples/existing-cloudtrail-iam-role
  aws/modules/cloudtrail/examples/existing-cloudtrail
  gcp/
  gcp/modules/service_account/examples/default-project-level-service-account
  #gcp/modules/service_account/examples/custom-organization-level-service-account
  gcp/modules/config/examples/environment-variables-project-level-config
  #gcp/modules/config/examples/existing-service-account-org-level-config
  gcp/modules/config/examples/organization-level-config
  gcp/modules/config/examples/project-level-config
  gcp/modules/audit_log/examples/environment-variables-project-level-audit-log
  #gcp/modules/audit_log/examples/existing-service-account-org-level-audit-log
  gcp/modules/audit_log/examples/organization-level-audit-log
  gcp/modules/audit_log/examples/project-level-audit-log
)

log() {
  echo "--> ${project_name}: $1"
}

warn() {
  echo "xxx ${project_name}: $1" >&2
}

integration_tests() {
  for tcase in ${TEST_CASES[*]}; do
    log "Running tests at $tcase"
    ( cd $tcase || exit 1
      terraform init
      terraform validate
      terraform plan
    ) || exit 1
  done
}

lint_tests() {
  for mod in ${MODULES[*]}; do
    log "fmt check for module $mod"
    ( cd $mod || exit 1
      terraform fmt -check
    ) || exit 1
  done
}

main() {
  lint_tests
  integration_tests
}

main || exit 99
