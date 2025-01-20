#!/bin/bash -e

N=$1
clients=$2
tests=$3

FIO=$(command -v fio) && $FIO --version
#FIO=/root/spdktest/fio/fio
rbd_prefix=fio_test_image
pool=nvmeof
test_dir=tmp
fio_conf=$test_dir/fio-rbd-tmp.conf
fio_conf_head=${fio_conf}-head
fio_conf_tail=${fio_conf}-tail
test_log=$test_dir/fio-rbd_$(date '+%Y-%m-%d_%H-%M').log

[[ -z $clients ]] && clients="client1,client2,client4,client5,client10,client14"
clients=${clients//,/ }
client_num=$(echo $clients|wc -w)
[[ -z $tests ]] && tests="randwrite randread"
[[ -z $N ]] && N=$client_num

N=$((N/client_num))

mkdir -p $test_dir
echo "Begin to Run test $test_log" | tee $test_log
echo "" >> $test_log

# header part fio conf
cat >$fio_conf_head<<EOF
[global]
#stonewall
description="Run \${RW} \${BS} rbd test"
bs=\${BS}
ioengine=rbd
clientname=admin
pool=${pool}
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

fio_args=
k=1
for client in $clients; do
	# rbdname part fio conf
	>$fio_conf_tail
	for j in $(seq $k $((N+k-1))); do
		cat >>$fio_conf_tail<<EOF

[test-job$((j-k+1))]
rbdname=fio_test_image$j
EOF
	done
	conf=${fio_conf}${N}_$client
	cat $fio_conf_head > $conf
	cat $fio_conf_tail >> $conf
	fio_args+=" --client $client $conf"
	k=$((j+1))
done

# run the tests
for test in $tests; do
	output=$test_log$((N*client_num))_$test
	cmd="RW=$test BS=4k IODEPTH=128 $FIO --output=$output $fio_args"
	echo $cmd >> $test_log
	eval $cmd
	cat $output >> $test_log
done
echo "" >> $test_log
echo "Finish test, see $test_log" | tee -a $test_log
