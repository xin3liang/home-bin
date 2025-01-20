#!/bin/bash -e
N=$1
cpusets=$2
tests=$3

block_size=512
RPC=/usr/libexec/spdk/scripts/rpc.py
#RPC="echo $RPC"
BDEVPERF=/usr/libexec/spdk/scripts/bdevperf.py
#BDEVPERF="echo $BDEVPERF"
rbd_prefix=fio_test_image
#rbd_prefix=rbd
pool=nvmeof
test_dir=tmp
sumary=$test_dir/sumary.txt
test_log=$test_dir/bdev-rbd_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $N ]] && N=1
[[ -z $cpusets ]] && cpusets="$(lscpu|grep node1|awk '{print $4}')"
[[ -z $tests ]] && tests="randwrite randread"
cpusets=(${cpusets//,/ })
cpuset_num=${#cpusets[@]}

mkdir -p $test_dir
echo "Begin to Run test $test_log" | tee $test_log

# Create clusters and rbd bdevs
for j in $(seq 1 $N); do
        rbd=$rbd_prefix$j
        name=Ceph$j
        cluster=cluster$j
	index=$(( (j - 1) % cpuset_num ))
	cpu_list="[${cpusets[$index]}]"
        $RPC bdev_rbd_register_cluster $cluster --core-mask $cpu_list
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
for j in $(seq 1 $N); do
        name=Ceph$j
        cluster=cluster$j
        $RPC bdev_rbd_delete $name
        $RPC bdev_rbd_unregister_cluster $cluster
done
$RPC bdev_get_bdevs
echo "Finish test, see $test_log" | tee -a $test_log
