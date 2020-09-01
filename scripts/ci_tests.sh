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
  aws/modules/iam_role/examples/default-iam-role
  aws/modules/iam_role/examples/custom-iam-role
  aws/modules/iam_role/examples/skip-creation-iam-role
  aws/modules/config/examples/custom-config
  aws/modules/config/examples/default-config
  aws/modules/config/examples/existing-iam-role-config
  aws/modules/cloudtrail/examples/complete-cloudtrail
  aws/modules/cloudtrail/examples/consolidated-cloudtrail-multiple-lacework-tenants
  aws/modules/cloudtrail/examples/consolidated-cloudtrail
  aws/modules/cloudtrail/examples/existing-cloudtrail-iam-role
  aws/modules/cloudtrail/examples/existing-cloudtrail
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
