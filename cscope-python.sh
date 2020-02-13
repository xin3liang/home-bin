#!/bin/bash

cd `pwd`

set -x

DIR=.

if [ -n "$1" ] ;then
	DIR=$1
fi

find $(pwd)/$DIR -type f \( -name "*.py" ! -path "*test*" ! -path ".*" \) > pycscope.files
pycscope -i pycscope.files

set +x

