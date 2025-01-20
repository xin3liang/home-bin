#!/bin/bash

cd `pwd`

set -x

DIR=.

if [ -n "$1" ] ;then
	DIR=$1
fi

find -L $(pwd)/$DIR -type f \( ! -path "*test*" ! -path "*/.tox/*" ! -path "*/.git/*" -name "*.py"  \) > pycscope.files
pycscope -i pycscope.files
rm -f pycscope.files
set +x

