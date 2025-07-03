#!/bin/bash
proc_name=$1
numa=$2

[[ -z $proc_name ]] && proc_name=juicefs
[[ -z $numa ]] && numa=2

cpu_list=$(lscpu|grep node$numa|awk '{print $4}')

for pid in $(pgrep -x $proc_name); do
	echo "set $cpu_list $pid"
	taskset -acp $cpu_list $pid
done
