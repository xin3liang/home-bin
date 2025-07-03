#!/bin/bash
proc_name=$1
cpu_list=$2

[[ -z $proc_name ]] && proc_name=juicefs
[[ -z $cpu_list ]] && cpu_list=0-95


for pid in $(pgrep -x $proc_name); do
	echo "set $cpu_list $pid"
	taskset -acp $cpu_list $pid
done
