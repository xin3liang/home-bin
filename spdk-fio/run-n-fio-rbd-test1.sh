#!/bin/bash -e

N=$1
tests=$2

FIO=/root/spdktest/fio/fio && $FIO --version > /dev/null 2>&1 || FIO=$(command -v fio) && $FIO --version
rbd_prefix=fio_test_image
pool=nvmeof
log_dir=tmp
fio_conf=$log_dir/fio-rbd-tmp.conf
log=$log_dir/fio-rbd_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $tests ]] && tests="randwrite randread"
[[ -z $N ]] && N=1

mkdir -p $log_dir
echo "Begin to Run test $log" | tee $log

# header part fio conf
cat >$fio_conf<<EOF
[global]
#stonewall
description="Run \${RW} \${BS} rbd test"
bs=\${BS}
ioengine=rbd
clientname=admin
pool=${pool}
#busy_poll=1
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
#numa_cpu_nodes=0
EOF

# rbdname part fio conf
for j in $(seq 1 $N); do
        cat >>$fio_conf<<EOF

[test-job$j]
rbdname=fio_test_image$j
EOF
done

# run the tests
conf=$fio_conf$N
mv $fio_conf $conf
for test in $tests; do
        output=$log${N}_$test
        cmd="RW=$test BS=4k IODEPTH=128 $FIO $conf --output=$output --numjobs=1"
        echo $cmd >> $log
        eval $cmd
        cat $output >> $log
done
echo "Finish test, see $log" | tee -a $log
grep IOPS= -rn $log
