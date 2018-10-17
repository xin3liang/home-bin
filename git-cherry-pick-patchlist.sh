#!/bin/bash

set -ex

patchlist=

## patch list passed by file or params
case $1 in
-f) patchlist=$(awk '{print $1}' $2|tac) ;;
*) patchlist=$@ ;;
esac

for patch in ${patchlist}
do
	git cherry-pick -s $patch
done

#set +x

