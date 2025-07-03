#!/bin/bash -e

N=$1
tests=$2
direct=$3
test_dir=$4
numa=$5
MAX_SIZE=100

FIO=/root/spdktest/fio/fio && $FIO --version > /dev/null 2>&1 || FIO=$(command -v fio) && $FIO --version
log_dir=tmp
fio_conf=$log_dir/fio-fs-tmp.conf
log=$log_dir/fio-fs_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="write read"
[[ -z $test_dir ]] && test_dir="/root/juicefstest/mount-fs/fio"
[[ -z $numa ]] && numa=2
[[ -z $direct ]] && direct=1

mkdir -p $log_dir
echo "Begin to Run test $log" | tee $log

# header part fio conf
cat >$fio_conf<<EOF
[global]
description="Run \${RW} bs=\${BS} size=\${SIZE} direct=\${DIRECT} file test on dir: ${DIRECTORY}"
directory=\${DIRECTORY}
rw=\${RW}
bs=\${BS}
size=\${SIZE}
ioengine=io_uring
thread=1
group_reporting=1
direct=\${DIRECT}
ramp_time=5s
end_fsync=1

[test-job1]
EOF

# run the tests
for (( i=1; i <= $N; i*=4 )); do
	bs=${i}K
	size=${i}G
	(( i > MAX_SIZE )) && size=${MAX_SIZE}G
	for test in $tests; do
		output=${log}_${bs}_$test

		(free -g && sync && echo 3 > /proc/sys/vm/drop_caches && free -g) > /dev/null  
		cmd="RW=$test BS=$bs SIZE=$size DIRECT=$direct DIRECTORY=$test_dir numactl --cpunodebind=$numa --membind=$numa $FIO $fio_conf --output=$output --numjobs=1"
		echo $cmd >> $log
		eval $cmd
		cat $output >> $log
	done
done
echo "Finish test, see $log" | tee -a $log
grep IOPS= -rn $log
