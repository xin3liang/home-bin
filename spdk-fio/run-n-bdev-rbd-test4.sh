#!/bin/bash -e
N=$1
tests=$2
bdevs_per_cluster=$3

block_size=512
RPC=/usr/libexec/spdk/scripts/rpc.py
BDEVPERF=/usr/libexec/spdk/scripts/bdevperf.py
rbd_prefix=fio_test_image
#rbd_prefix=rbd
pool=nvmeof
test_dir=tmp
sumary=$test_dir/sumary.txt
test_log=$test_dir/bdev-rbd_$(date '+%Y-%m-%d_%H-%M').log

# debug
#RPC="echo $RPC"
#BDEVPERF="echo $BDEVPERF"

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="randwrite randread"
[[ -z $bdevs_per_cluster ]] && bdevs_per_cluster=1

mkdir -p $test_dir
echo "Begin to Run test $test_log" | tee $test_log

# Create clusters and rbd bdevs
cluster_num=0
for j in $(seq 1 $N); do
        rbd=$rbd_prefix$j
        name=Ceph$j
	if ! (( (j-1) % bdevs_per_cluster )); then
		(( cluster_num++ )) || true
		cluster=cluster$cluster_num
		$RPC bdev_rbd_register_cluster $cluster
	fi
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
        $RPC bdev_rbd_delete $name
done
for j in $(seq 1 $cluster_num); do
        cluster=cluster$j
        $RPC bdev_rbd_unregister_cluster $cluster
done

$RPC bdev_get_bdevs
echo "Finish test, see $test_log" | tee -a $test_log
