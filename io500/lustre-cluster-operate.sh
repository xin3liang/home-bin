#!/bin/bash -e

NAME=${NAME:-"multinode"}
LUSTRE=${LUSTRE:-"/lib64/lustre"}
. $LUSTRE/tests/test-framework.sh > /dev/null 2>&1
init_test_env $@ > /dev/null 2>&1
init_logging > /dev/null 2>&1

clients=$CLIENTS
servers=$(comma_list $(all_server_nodes))
server_node_count=$(get_node_count $(all_server_nodes))
mgs_node_count=$(get_node_count $(mgs_node))
mdts_node_count=$(get_node_count $(mdts_nodes))
osts_node_count=$(get_node_count $(osts_nodes))
echo "Mdt: $MDSCOUNT, ost: $OSTCOUNT"
echo "Client(s): $CLIENTCOUNT $clients"
echo "Server(s): $server_node_count $servers"
echo "  mgs nodes: $mgs_node_count $(mgs_node)"
echo "  mdts nodes: $mdts_node_count $(mdts_nodes)"
echo "  osts nodes: $osts_node_count $(osts_nodes)"

if ! is_mounted $MOUNT; then
	echo "$MOUNT is not mounted"
else
	echo "$MOUNT is mounted"
fi
#restore_mount $MOUNT || error "Restore $MOUNT failed"
setupall
