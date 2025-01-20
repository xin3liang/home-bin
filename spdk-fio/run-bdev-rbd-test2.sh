#!/bin/bash -e
N=$1
cpuset=$2
tests=$3
cpus_per_cluster=$4

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
[[ -z $cpuset ]] && cpuset="$(lscpu|grep node1|awk '{print $4}')"
[[ -z $tests ]] && tests="randwrite randread"
[[ -z $cpus_per_cluster ]] && cpus_per_cluster=5
cpu_start=${cpuset%%-*}
cpu_end=${cpuset##*-}

mkdir -p $test_dir
echo "Begin to Run test $test_log" | tee $test_log

for (( i=1; i <= $N; i*=2 )); do
(( i > max_rbd_num )) && i=$max_rbd_num
        start=$cpu_start
        (( end = start + cpus_per_cluster - 1 ))
        # Create clusters and rbd bdevs
        for j in $(seq 1 $i); do
                rbd=$rbd_prefix$j
                name=Ceph$j
                cluster=cluster$j
                cpu_list="[${start}-${end}]"
                $RPC bdev_rbd_register_cluster $cluster --core-mask "$cpu_list"
                $RPC bdev_rbd_create  -c $cluster --name $name $pool $rbd $block_size
                ((  (start + cpus_per_cluster * 2 - 1) <= cpu_end )) && (( start = start + cpus_per_cluster)) || start=$cpu_start
                (( end = start + cpus_per_cluster - 1 ))
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
