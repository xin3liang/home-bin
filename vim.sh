#!/bin/bash

cd `pwd`

set -x

ctags -R
find $(pwd) -name "*.[ch]" -o -name "*.cc" -o -name "*.cpp" > cscope.files
cscope -bkq -i cscope.files

set +x

