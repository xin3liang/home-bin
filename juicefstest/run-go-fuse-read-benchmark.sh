#!/bin/bash -e

tests=$1
cpu_list=$2
test_run_dir=$3
pwd_dir=$(pwd)

[[ -z $tests ]] && tests="BenchmarkGoFuseMemoryRead"
[[ -z $cpu_list ]] && cpu_list=1
[[ -z $test_run_dir ]] && test_run_dir=/root/juicefstest/go-fuse

test_run_dir=$(realpath $test_run_dir)
log_dir=/root/juicefstest/tmp
log=$log_dir/go-fuse-benchmark_$(date '+%Y-%m-%d_%H-%M').log

echo "Begin to Run test $log" | tee $log
echo "Running at $test_run_dir ..." | tee $log

cd $test_run_dir &&
cmd="go test ./benchmark -test.bench $tests -test.cpu $cpu_list  -test.benchtime 10s 2>&1"
echo $cmd >> $log
eval $cmd | tee -a $log 

echo "Finish test, see $log" | tee -a $log
