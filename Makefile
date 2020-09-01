default: ci

# TODO @afiune add more prerequisites and checks like having terraform installed
AWS_REGION?=us-west-2
export AWS_REGION
GOOGLE_PROJECT?=customerdemo1
export GOOGLE_PROJECT

ci:
	scripts/ci_tests.sh

release: ci
	scripts/release.sh prepare
