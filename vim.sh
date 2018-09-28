#!/bin/bash

cd `pwd`

set -x

DIR=.

if [ -n "$1" ] ;then
	DIR=$1
fi

ctags -R $DIR

find $(pwd)/$DIR -type f \( -name "*.[ch]" -o -name "*.cpp" ! -path \
"*test*" \) > cscope.files
cscope -bkq -i cscope.files

#find $(pwd)/$DIR -type f \( -name "*.py" ! -path "*test*" \) > pycscope.files
#pycscope -i pycscope.files

set +x

