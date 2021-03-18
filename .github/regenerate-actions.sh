#!/bin/bash
set -eou pipefail

yaml --version > /dev/null || {
	echo "yaml not installed, install with:"
	echo "  pip install ruamel.yaml.cmd"
	exit 1
}

generate () {
	echo "generating $1"
	echo "# WARNING: This file is automatically generated by ../regenerate-actions.sh" > "workflows/$1"
	cat shared.yml "$1" \
		| yaml merge-expand - - \
		| perl -0777 -pe 's|(#<shared>.+?#<\/shared>)||gs' \
		| perl -0777 -pe 's|#<\/shared>\s*||gs' \
		>> "workflows/$1"
}

generate continuous-integration.yml
echo "done"
