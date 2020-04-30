#!/bin/bash

cd `pwd`

set -x

DIR=.

if [ -n "$1" ] ;then
	DIR=$1
fi

find $(pwd)/$DIR -type f \( ! -path "*test*" ! -path "*/.tox/*" ! -path "*/.git/*" -name "*.py"  \) > pycscope.files
pycscope -i pycscope.files

set +x

