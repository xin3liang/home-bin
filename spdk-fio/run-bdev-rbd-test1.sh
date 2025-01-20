#!/bin/bash -e
N=$1
tests=$2

max_rbd_num=100
block_size=512
RPC=/root/spdktest/spdk/scripts/rpc.py  && $RPC --help > /dev/null 2>&1 ||
       	RPC=/root/work/spdk/scripts/rpc.py  && $RPC --help > /dev/null 2>&1 ||
       	RPC=/usr/libexec/spdk/scripts/rpc.py && $RPC --help > /dev/null 
BDEVPERF=/root/spdktest/spdk/examples/bdev/bdevperf/bdevperf.py && $BDEVPERF --help > /dev/null  2>&1 ||
       	BDEVPERF=/root/work/spdk/examples/bdev/bdevperf/bdevperf.py && $BDEVPERF --help > /dev/null 2>&1 ||
       	BDEVPERF=/usr/libexec/spdk/scripts/bdevperf.py && $BDEVPERF --help > /dev/null
rbd_prefix=fio_test_image
#rbd_prefix=rbd
pool=nvmeof
test_dir=tmp
sumary=$test_dir/sumary.txt
test_log=$test_dir/bdev-rbd_$(date '+%Y-%m-%d_%H-%M').log

## debug
#RPC="echo $RPC"
#BDEVPERF="echo $BDEVPERF"

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="randwrite randread"

mkdir -p $test_dir
echo "Begin to Run test $test_log" | tee $test_log

for (( i=1; i <= $N; i*=2 )); do
(( i > max_rbd_num )) && i=$max_rbd_num
        # Create clusters and rbd bdevs
        for j in $(seq 1 $i); do
                rbd=$rbd_prefix$j
                name=Ceph$j
                cluster=cluster$j
                $RPC bdev_rbd_register_cluster $cluster
                $RPC bdev_rbd_create  -c $cluster --name $name $pool $rbd $block_size
        done

        # run performance tests
        for test in $tests; do
                > $sumary
                cmd="$BDEVPERF perform_tests -w $test | tee -a $test_log"
                echo $cmd >> $test_log
                eval $cmd
                sleep 2s && cat $sumary >>  $test_log
        done

        # Delete clusters and rbd bdevs
        for j in $(seq 1 $i); do
                name=Ceph$j
                cluster=cluster$j
                $RPC bdev_rbd_delete $name
                $RPC bdev_rbd_unregister_cluster $cluster
        done
        $RPC bdev_get_bdevs
done
echo "Finish test, see $test_log" | tee -a $test_log
