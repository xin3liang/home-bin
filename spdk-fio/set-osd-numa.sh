#!/bin/bash -x

SERVER_NUM=3
OSD_NUM=96
NUMA_NUM=4

numa=-1
for i in $(seq 0 $((OSD_NUM-1))); do
        if ! (( i%SERVER_NUM )); then
                (( numa++ ))
                (( numa = numa % NUMA_NUM))
        fi
        echo ceph config set osd.$i osd_numa_node $numa
done
echo ceph orch restart osd.default_drive_group
