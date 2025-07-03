#!/bin/bash -e

N=$1
tests=$2
cpu=$3
test_run_dir=$5

[[ -z $N ]] && N=1
[[ -z $tests ]] && tests="BenchmarkGoFuseMemoryRead"
[[ -z $test_run_dir ]] && test_run_dir="go-fuse2"
[[ -z $cpu ]] && cpu=1
test_run_dir=$(basename $test_run_dir)

datetime=$(date '+%Y-%m-%d_%H-%M')
debug_dir=/root/juicefstest/debug/${test_run_dir}-benchmark/${datetime}
log_dir=/root/juicefstest/tmp/${test_run_dir}-benchmark/${datetime}
log=$log_dir/run.log

mkdir -p $log_dir
mkdir -p $debug_dir 
echo "Begin to Run tests at dir: $(readlink -f $test_run_dir)" | tee $log
echo "log: $log" | tee -a $log

# run the tests
(sync && echo 3 > /proc/sys/vm/drop_caches) > /dev/null  
cd $test_run_dir
for (( i=1; i <= $N; i*=2 )); do
	time=$i
	output=trace-${test_run_dir}-${tests}-cpu${cpu}-${time}s-$(hostname).out
	cmd="go test ./benchmark -test.bench $tests -test.cpu $cpu -test.benchtime ${time}s  -test.outputdir $debug_dir -trace $output"
	echo "run: $cmd" | tee -a $log
	eval $cmd | tee -a $log
done

echo "Finish test, see $log" | tee -a $log
