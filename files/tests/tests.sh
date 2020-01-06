#!/bin/bash
#
# Shell script to test the Hashicorp Tools image.
#
# Copyright 2016-2020, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

# Variables

/bin/echo "=== Docker Build Test ==="

/bin/echo -n "[TEST] Check if Python is installed... "
python --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 1
fi

/bin/echo -n "[TEST] Check if AWS CLI is installed... "
aws --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 2
fi

/bin/echo -n "[TEST] Check if Azure CLI is installed... "
az --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 3
fi

/bin/echo -n "[TEST] Check if Git is installed... "
git --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 5
fi

/bin/echo -n "[TEST] Check if Hub is installed... "
hub --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 6
fi

/bin/echo -n "[TEST] Check if Packer is installed... "
packer --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 7
fi

/bin/echo -n "[TEST] Check if Terraform is installed... "
terraform --version &>/dev/null
if [[ "$?" -eq "0" ]]; then
  /bin/echo 'OK'
else
  /bin/echo 'Failed'
  exit 8
fi

exit 0
