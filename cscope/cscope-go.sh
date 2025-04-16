#!/bin/bash

# generate cscope index files in current directory
# the generated cscope index files also include go standard packages

#if [ "$GOROOT" = "" ]
#then
#echo "GOROOT is not set"
#    exit 1
#fi
#
#go_pkg_src=$GOROOT/pkg
#
#find $go_pkg_src -name "*.go" -print > cscope.files
find . -type f \( ! -path "*test.go"  ! -path "*/.git/*" -name "*.go"  \) -print > cscope.files
#find ~/go/pkg -name "*.go" -print >> cscope.files

if cscope -b -k; then
echo "Done"
else
echo "Failed"
    exit 1
fi
rm -f cscope.files
