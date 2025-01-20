#!/bin/bash

cd `pwd`

set -x

DIR=.

if [ -n "$1" ] ;then
	DIR=$1
fi

rusty-tags -v vi
ctags -R $DIR

find . -name "*.rs" -print > cscope.files
cscope -bkq -i cscope.files
rm -f cscope.files
set +x

