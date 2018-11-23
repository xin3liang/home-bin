#!/bin/bash


# sending mode
run_mode=
send_mode=
process=1
thread=
time=
port=5201

usage() {
cat << EOF
usage:
iperf-test.sh <-c host|-s> [options]
    -h, --help		display this help and exit
    -c		        client mode
    -s			server mode
    -p                  iperf process
client options:
    -m        		send mode: regular, reverse, mix
    -t                  sending time by second
    -P                  thread num of each process

EOF
}

###################################################################################
# Get parameters
###################################################################################
while test $# != 0
do
option=
optarg=
second_shift=

    case $1 in
        --*=*) option=`expr "X$1" : 'X\([^=]*\)='` ; optarg=`expr "X$1" : 'X[^=]*=\(.*\)'` ; second_shift=:
            ;;  
        -*) option=$1 ; optarg=$2 ; second_shift=shift
            ;;  
    esac

    case $option in
        -h|--help) usage ; exit ;;
        -s) run_mode=$option; second_shift=: ;;
        -c) run_mode="$option $optarg" ;;
        -t) time="$option $optarg" ;;
        -P) thread="$option $optarg" ;;
        -m) send_mode=$optarg ;;
        -p) process=$optarg ;;
        *) echo "Unknow option $option!" ; usage ; exit 1 ;;
    esac
    
    shift
    ${second_shift}
done

#
# parse params
#
if [[ -z $run_mode ]]; then
	echo "Please specifi running mode:-s|-c!" ; usage ; exit 1
fi

extra_opt=
if [[ $send_mode = "reverse" ]]; then
	extra_opt="-R"
fi

if [[ $run_mode = "-s" ]]; then
	send_mode=
	thread=
	time=
fi

while [ $process -gt 0 ]; do

        iperf3 -p $port $run_mode $time $thread $extra_opt & 

	if [[ $send_mode = "mix" ]]; then
		if [[ -z $extra_opt ]]; then
			extra_opt="-R"
		else
			extra_opt=
		fi
	fi
	(( process-- ))
	(( port++ ))
	echo "Welcone $process times"
done

wait
echo "Finish test. run $ iperf3 -p $port $run_mode $time $thread $extra_opt & "
