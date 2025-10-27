#!/bin/bash -e

dirs=$1
[[ -z $dirs ]] && dirs=.
dirs=${dirs//,/ }

src_file="cscope.files"
cscope_cmd="cscope -qb"
find_src_files() {
	rm -f $src_file
	for dir in $dirs; do
		cmd="find -L $(pwd)/$dir -type f $file_filter >> $src_file"
		echo $cmd; eval $cmd
	done
}

parse_src_files() {
	ctags -VL $src_file
	$cscope_cmd -i $src_file
	rm -f $src_file
}
