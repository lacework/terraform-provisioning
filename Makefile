default: ci

# TODO @afiune add more prerequisites and checks like having terraform installed
AWS_REGION?=us-west-2
export AWS_REGION

ci:
	scripts/ci_tests.sh

release: ci
	scripts/release.sh prepare
