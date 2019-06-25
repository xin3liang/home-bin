#!/bin/bash

set -ex

patchlist=

## patch list passed by file or params
case $1 in
-f) patchlist=$(awk '{print $1}' $2|tac) ;;
*) patchlist=$@ ;;
esac

function insert_info() {
	echo "commit `head -1 $1 | cut -d ' ' -f 2` upstream." >> /tmp/commit_msg

		BLANK_LINE=`sed -n '/^$/=' $1 |sed -n "1"p`
		let BLANK_LINE=BLANK_LINE-1

		sed -i "${BLANK_LINE} r /tmp/commit_msg" $1
		sed -i '/commit/d' /tmp/commit_msg
}

tmpdir="tmp-$(uuidgen)"
mkdir -p $tmpdir
i=1
for patch in ${patchlist}
do
	patchfile="$tmpdir/$(printf "%04d.patch" "$i")"
	git format-patch -1 $patch --stdout > $patchfile
	insert_info $patchfile
	git am -s $patchfile
	(( i= i+1 ))
done

#set +x

