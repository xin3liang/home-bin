#!/bin/bash

N=$1
tests=$2

FIO=$(command -v fio)
#FIO=/root/spdktest/fio/fio
rbd_prefix=fio_test_image
pool=nvmeof
fio_dir=tmp
fio_conf=$fio_dir/fio-rbd-tmp.conf
fio_log=$fio_dir/fio-rbd_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $tests ]] && tests="randwrite randread"
[[ -z $N ]] && N=1

mkdir -p $fio_dir
echo "Begin to Run test $fio_log" | tee $fio_log

# header part fio conf
cat >$fio_conf<<EOF
[global]
description="Run \${RW} \${BS} NVMe ssd test"
bs=\${BS}
#ioengine=libaio
ioengine=io_uring
thread=1
group_reporting=1
direct=1
verify=0
norandommap=1
time_based=1
ramp_time=10s
runtime=1m
iodepth=\${IODEPTH}
rw=\${RW}
EOF

# rbdname part fio conf
for j in $(seq 1 $N); do
        cat >>$fio_conf<<EOF

[test-job$j]
filename=/dev/nvme2n$j
EOF
done

# run the tests
conf=$fio_conf$N
mv $fio_conf $conf
for test in $tests; do
        output=$fio_log${N}_$test
        cmd="RW=$test BS=4k IODEPTH=128 $FIO $conf --output=$output --numjobs=1"
        echo $cmd >> $fio_log
        eval $cmd
        cat $output >> $fio_log
done
echo "Finish test, see $fio_log" | tee -a $fio_log
