#!/bin/bash

set -ex

roce_core_dir="infiniband/core infiniband/sw infiniband/ulp"
patchlist=
mod=
infile=
outfile=

## patch list passed by file or params
while [ $# -gt 0 ]
do
	case "$1" in
	-f) infile=$2 ;;
	-m) mod=$2; outfile=$mod-autogen-update-patchlist.txt ;;
	*) exit 1 ;;
	esac
	shift 2
done

function is_core_relative_patch() {
	git_show_stat=$(git show --stat $1)

	if [ $mod == "roce" ] ; then
		grep_dir=$roce_core_dir
	fi

	for grep_str in $grep_dir
	do
		ret=$(echo $git_show_stat|grep $grep_str) || true 
		if [ ! -z "$ret"  ]; then
			echo "true";
			return 0
		fi
	done
	echo "false"
	return 0
}

rm -f $outfile

while read -r line
do
	commitid=$(echo $line|awk '{print $1}')
	ret=$(is_core_relative_patch $commitid)
	if [ "$ret" == "false" ]; then
		echo $line >> $outfile
	fi
done < $infile

#set +x

