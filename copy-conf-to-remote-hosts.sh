#!/bin/bash -e

server_num=${SERVER_NUM:-6}
client_num=${CLIENTCOUNT:-5}
max_num=$(( client_num > server_num ? client_num : server_num ))
clients=${CLIENTS:-"client2,client3,client4,client5,client10,client11,client14"}
clients=${clients//,/ }

for  i in $(seq $max_num); do
        if (( i <= server_num )); then
                host=server$i
                #scp multinode.sh $host:io500test/
                #scp /etc/hosts $host:/etc
        fi
        #if (( i <= client_num )); then
        #       scp multinode.sh client$i:io500test/
        #fi
done

for client in $clients; do
        #scp multinode.sh $client:io500test/
        #scp /etc/hosts $client:/etc
        #scp mpi-hosts $client:io500test/
        #scp -r io500 $client:io500test/
        scp -r  config-* $client:io500test/
done
