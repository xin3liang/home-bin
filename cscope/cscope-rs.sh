#!/bin/bash -e

## Usage: cscope-rs.sh [dir1,dir2,dir3...]
. common.sh
cscope_cmd="pycscope"
file_filter='\( ! -path "*test*" ! -path "*/.tox/*" ! -path "*/.git/*" -name "*.py" \)'

rusty-tags -v vi
find_src_files
parse_src_files


