#/bin/bash
N=$1
#IMAGE_NAME_PREFIX=rbd
IMAGE_NAME_PREFIX=fio_test_image
POOL=nvmeof

[[ -z $N ]] && N=20 

GATEWAY_NAME=server2-1
GATEWAY_IP=192.168.0.21
GATEWAY_NAME2=client10
GATEWAY_IP2=192.168.0.100
GATEWAY_PORT=5500
SUBSYSTEM_NQN=nqn.2016-06.io.spdk:cnode1
NVMEOF_CLI="podman run --rm quay.io/xin3liang0/nvmeof-cli:latest --server-address $GATEWAY_IP --server-port $GATEWAY_PORT"
NVMEOF_CLI2="podman run --rm quay.io/xin3liang0/nvmeof-cli:latest --server-address $GATEWAY_IP2 --server-port $GATEWAY_PORT"

for i in $(seq $N); do
        rbd=$POOL/$IMAGE_NAME_PREFIX$i
        echo "Delete nvme rbd $rbd"
	$NVMEOF_CLI namespace del --subsystem $SUBSYSTEM_NQN --nsid $i
	#rbd rm $rbd
done
rbd -p $POOL disk-usage
$NVMEOF_CLI namespace list --subsystem $SUBSYSTEM_NQN
