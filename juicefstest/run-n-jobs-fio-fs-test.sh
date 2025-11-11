#!/bin/bash -e

N=$1
direct=$2
warmup=$3
tests=$4
numas=$5
test_dir=$6

fs_name=jfs1
storage=minio
host=server2
API=http://$host:9000
META_DB_URL=redis://$host/1
BUCKET_URL=$API/$fs_name
ACCESS_KEY=minioadmin
SECRET_KEY=minioadmin
#META_DB_URL=sqlite3:///root/juicefstest/jfs/sqlite3_db/$fs_name.db


FIO=/root/spdktest/fio/fio && $FIO --version > /dev/null 2>&1 || FIO=$(command -v fio) && $FIO --version
log_dir=tmp
fio_conf=$log_dir/fio-fs-tmp.conf
log=$log_dir/fio-fs_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="write read"
[[ -z $test_dir ]] && test_dir="/root/mount-fs/jfs/jfs1/fio"
[[ -z $direct ]] && direct=1
[[ -z $warmup ]] && warmup=0

mkdir -p $log_dir
mkdir -p $test_dir
echo "Begin to Run test $log" | tee $log

# header part fio conf
cat >$fio_conf<<EOF
[global]
description="Run \${RW} bs=\${BS} size=\${SIZE} iodepth=\${IODEPTH} direct=\${DIRECT} end_fsync=1 file test on dir: \${DIRECTORY}"
directory=\${DIRECTORY}
rw=\${RW}
bs=\${BS}
size=\${SIZE}
#ioengine=io_uring
#ioengine=sync
thread=1
group_reporting=1
direct=\${DIRECT}
#ramp_time=2s
time_based=1
runtime=30s
end_fsync=1
iodepth=\${IODEPTH}

[test-job1]
EOF

# run the tests
#(rm -rf $test_dir/*) > /dev/null
#juicefs gc --delete $META_DB_URL 
#(free -g && sync && echo 3 > /proc/sys/vm/drop_caches && free -g) > /dev/null  
[[ -n $numas ]] && cmd_head="numactl --cpunodebind=$numas --membind=$numas"
for test in $tests; do
        output=${log}_${N}jobs_$test

	#(free -g && sync && echo 3 > /proc/sys/vm/drop_caches && free -g) > /dev/null  
	cmd="RW=$test BS=4M SIZE=1G IODEPTH=1 DIRECT=$direct DIRECTORY=$test_dir $cmd_head $FIO $fio_conf --output=$output --numjobs=$N"
	[[ "$warmup" == "1" ]] && (juicefs warmup --threads 24 $test_dir 2>&1) > /dev/null 
        echo $cmd >> $log
        echo $cmd; eval $cmd
        cat $output >> $log
done
echo "Finish test, see $log" | tee -a $log
grep IOPS= -rn $log
