#!/bin/bash -e

N=$1
tests=$2
direct=$3
test_dir=$4

fs_name=jfs2
META_DB_URL=sqlite3:///root/juicefstest/jfs/sqlite3_db/$fs_name.db

FIO=/root/spdktest/fio/fio && $FIO --version > /dev/null 2>&1 || FIO=$(command -v fio) && $FIO --version
log_dir=tmp
fio_conf=$log_dir/fio-fs-tmp.conf
log=$log_dir/fio-fs_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="write read"
[[ -z $test_dir ]] && test_dir="/root/juicefstest/mount-fs/fio"
[[ -z $direct ]] && direct=1

mkdir -p $log_dir
echo "Begin to Run test $log" | tee $log

# header part fio conf
cat >$fio_conf<<EOF
[global]
description="Run \${RW} bs=\${BS} size=\${SIZE} direct=\${DIRECT} iodepth=\${IODEPTH} file test on dir: \${DIRECTORY}"
directory=\${DIRECTORY}
rw=\${RW}
bs=\${BS}
size=\${SIZE}
ioengine=io_uring
thread=1
group_reporting=1
direct=\${DIRECT}
#ramp_time=5s
time_based=1
runtime=20s
end_fsync=1
iodepth=\${IODEPTH}

[test-job1]
EOF

# run the tests
for (( i=1; i <= $N; i*=2 )); do
	bs=${i}K
	(rm -rf $test_dir/* ; juicefs gc --delete $META_DB_URL 2>&1) > /dev/null
	(free -g && sync && echo 3 > /proc/sys/vm/drop_caches && free -g) > /dev/null  
	for test in $tests; do
		output=${log}_${bs}_$test

		cmd="RW=$test BS=$bs SIZE=20G DIRECT=$direct IODEPTH=64 DIRECTORY=$test_dir $FIO $fio_conf --output=$output --numjobs=1"
		echo $cmd >> $log
		eval $cmd
		cat $output >> $log
	done
done
echo "Finish test, see $log" | tee -a $log
grep IOPS= -rn $log
