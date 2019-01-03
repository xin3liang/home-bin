#!/bin/bash

set -ex

testParam="send read write atomic"
testCount=10


## params
case $1 in
*) testParam=$@ ;;
esac

for opt in ${testParam}
do
	count=1
	while [ $count -le $testCount ]
	do
		echo "$count: ib_${opt}_bw test =========================================================>"
                ib_${opt}_bw -d hns_0 &
                ib_${opt}_bw -d hns_0 localhost
		(( count++ ))
	done
done

#set +x

