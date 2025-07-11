#!/bin/bash -e

N=$1
tests=$2
direct=$3
end_fsync=$4
test_dir=$5
fs_name=jfs2
META_DB_URL=sqlite3:///root/juicefstest/jfs/sqlite3_db/$fs_name.db

FIO=/root/spdktest/fio/fio && $FIO --version > /dev/null 2>&1 || FIO=$(command -v fio) && $FIO --version
log_dir=tmp
fio_conf=$log_dir/fio-fs-tmp.conf
log=$log_dir/fio-fs_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="write"
[[ -z $test_dir ]] && test_dir="/root/juicefstest/mount-fs/fio"
[[ -z $direct ]] && direct=1
[[ -z $end_fsync ]] && end_fsync=1

mkdir -p $log_dir
echo "Begin to Run test $log" | tee $log

# header part fio conf
cat >$fio_conf<<EOF
[global]
description="Run \${RW} bs=\${BS} size=\${SIZE} direct=\${DIRECT} end_fsync=\${END_FSYNC} file test on dir: \${DIRECTORY}"
directory=\${DIRECTORY}
rw=\${RW}
bs=\${BS}
size=\${SIZE}
ioengine=sync
thread=1
group_reporting=1
direct=\${DIRECT}
#ramp_time=5s
end_fsync=\${END_FSYNC}
EOF

# rbdname part fio conf
for j in $(seq 1 $N); do
	cat >>$fio_conf<<EOF

[test-job$j]
EOF
done

# run the tests
for test in $tests; do
        output=${log}_${bs}_$test

	#(rm -rf $test_dir/* ; juicefs gc --delete $META_DB_URL 2>&1) > /dev/null
	#(free -g && sync && echo 3 > /proc/sys/vm/drop_caches && free -g) > /dev/null  
	cmd="RW=$test BS=4M SIZE=1G DIRECT=$direct END_FSYNC=$end_fsync DIRECTORY=$test_dir $FIO $fio_conf --output=$output --numjobs=1"
        echo $cmd >> $log
        eval $cmd
        cat $output >> $log
done
echo "Finish test, see $log" | tee -a $log
grep IOPS= -rn $log
