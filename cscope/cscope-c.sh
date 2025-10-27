#!/bin/bash -e

## Usage: cscope-c.sh [dir1,dir2,dir3...]
. common.sh
file_filter='\( -name "*.[ch]" -o -name "*.cpp" -o -name "*.hh" -o -name "*.cc" ! -path "*test*" ! -path "*/.git/*" \)'

find_src_files
parse_src_files
