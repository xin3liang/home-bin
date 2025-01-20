#!/bin/bash -e

. ~/io500test/.venv/bin/activate
. ~/io500test/multinode.sh > /dev/null 2>&1 || true

nodes="client,server"
config_ini=${CONFIG_INI:-$1}
client_num=${CLIENTCOUNT:-1}
max_mdt_num=${MAX_MDT_NUM:-24}
max_ost_num=${MAX_OST_NUM:-96}
max_np=${MAX_NP:-$(( $(nproc)*client_num ))}
start_np=${START_NP:-$((client_num*16))}
log_file=~/io500test/results/$(date +%Y.%m.%d-%H.%M.%S)-io500.log

if [[ -z "$config_ini" ]]; then
    config_ini=~/io500test/config-minimal.ini
fi
touch $log_file
ls $config_ini $log_file

#for (( mdt=4,ost=8; ost<=max_ost_num; mdt+=2,ost+=2 )); do
#    if (( mdt > max_mdt_num )); then
#	    (( mdt=max_mdt_num ))
#    fi

    ## Setup Lustre FS
    #echo "Setup file system mdt=$mdt ost=$ost ..." | tee -a $log_file
    #ansible -i ~/io500test/ansible-hosts $nodes -m shell \
    #	-a "lustre_rmmod && modprobe lustre && lctl list_nids" >> $log_file 2>&1
    #export NAME=multinode MDSCOUNT=$mdt OSTCOUNT=$ost 
    #/lib64/lustre/tests/llmount.sh >> $log_file 2>&1

    for (( np=start_np; np<=max_np; np+=client_num )); do
	# check fs is ok
	(lfs df -h && lfs df -h |grep filesystem_summary) >> $log_file 2>&1

	# run io500 test
	echo "client_num: $client_num, cores_per_node: $(( np/client_num )), np: $np" | tee -a $log_file 
        NP=$np ./io500.sh $config_ini 2>&1 | tee -a $log_file

    done

    ## Cleanup Lustre FS
    #echo "Cleanup file system..." | tee -a $log_file
    #/lib64/lustre/tests/llmountcleanup.sh >> $log_file 2>&1
#done
echo "Finish io500 test." | tee -a $log_file
echo "See test running output at $log_file"
