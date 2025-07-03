#!/bin/bash

cd /sys/fs/fuse/connections
for f in *; do
	echo $f
	echo hoi > $f/abort
done

for f in $(mount|grep fuse|grep tmp| awk '{print $3;}'); do
	fusermount -u $f
done

