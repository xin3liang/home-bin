#!/bin/bash
cpu_num=96
osd_num=24

(( cpus_per_osd = cpu_num / osd_num ))
start=0
(( end = start + cpus_per_osd - 1 ))

for pid in $(pgrep -x ceph-osd); do
	cpu_list=${start}-${end}
	echo "set $cpu_list $pid"
	taskset -acp $cpu_list $pid
	(( start = start + cpus_per_osd))
	(( end = start + cpus_per_osd - 1 ))
done
