#!/bin/bash -e

## Usage: cscope-go.sh [dir1,dir2,dir3...]
. common.sh
file_filter='\( ! -path "*test.go"  ! -path "*/.git/*" -name "*.go" \)'

find_src_files
parse_src_files

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
#find ~/go/pkg -name "*.go" -print >> cscope.files
