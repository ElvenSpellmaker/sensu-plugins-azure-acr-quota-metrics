#!/bin/bash

if [ "$TRAVIS" = true ]; then
	echo "This is Travis, don't pre-install \`az\`... Exiting 0..."
	exit 0
fi

ENV_DIR="/az-python"

check_error()
{
	if [ $1 -ne 0 ]; then
		echo 'Failed to install!' >&2
		exit $1
	fi
}

AZ_PACKAGE='azure-cli'
AZ_VERSION='2.0.31'

if [ -f "$ENV_DIR/bin/activate" ]; then
	. "$ENV_DIR/bin/activate"
	if [ "$(pip freeze | grep -oP "$AZ_PACKAGE"'==\K.*')" == "$AZ_VERSION" ]; then
		echo '`az` is already installed in the virtualenv at the correct version!'
		exit 0
	fi
fi

virtualenv $ENV_DIR
check_error $?

. $ENV_DIR/bin/activate
check_error $?

pip install --upgrade 'pip==10.0.1'
check_error $?
# `azure-cli` will actually replace wheel with this version...
pip install --upgrade 'wheel==0.30.0'
check_error $?
pip install --upgrade 'setuptools==39.0.1'
check_error $?
pip install --upgrade "$AZ_PACKAGE==$AZ_VERSION"
check_error $?
