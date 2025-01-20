#!/bin/bash 

server_num=${SERVER_NUM:-6}
client_num=${CLIENTCOUNT:-5}
max_num=$(( client_num > server_num ? client_num : server_num ))
clients=${CLIENTS:-"client2,client3,client4,client5,client10,client13,client14"}
clients=${clients//,/ }
servers="server1 server5 server6"

for server in $servers; do
	echo $server
	#scp /etc/hosts $server:/etc 
	#scp multinode.sh $server:io500test/
	#scp parted_disks.sh $server:io500test/
done

for client in $clients; do
	echo $client
	#scp /etc/hosts $client:/etc 
	#scp multinode.sh $client:io500test/
	#scp -r io500 $client:io500test/
	scp -r  config-* $client:io500test/
	#scp lustre-cluster-operate.sh $client:io500test/
	#scp -r  *.repo $client:io500test/
	#scp -r mpich-4.2.1 $client:io500test/
	#scp mpich-x86_64 $client:io500test/
done
