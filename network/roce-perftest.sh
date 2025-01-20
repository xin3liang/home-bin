#!/bin/bash

set -ex

testParam="send read write atomic" # atomic not support yet for D06
testCount=10


## params
if [ $# -ge 1 ]; then
	case $1 in
	*) testParam=$@ ;;
esac
fi

while true; do
	for opt in ${testParam}
	do
		count=1
		while [ $count -le $testCount ]
		do
			echo "$count: ib_${opt}_bw test =========================================================>"
			ib_${opt}_bw -d hns_2 &
			sleep 0.1s
			ib_${opt}_bw -d hns_2 localhost
			wait
			(( count++ ))
		done
	done
done

#set +x

