#!/bin/bash -xe

disks="sda"
replicas=1 
storage_nodes=(10.30.96.1)
kolla_swift_base_image="kolla/debian-source-swift-base:liuxl-train"

echo "prepare disks"
index=-1
for d in $disks; do
	(( index++ ))
	sudo parted /dev/${d} -s -- mklabel gpt mkpart KOLLA_SWIFT_DATA 1 -1
	sudo mkfs.xfs -f -L d${index} /dev/${d}1
	sudo parted /dev/${d} print
done

echo "Generate Object Ring"
mkdir -p /etc/kolla/config/swift

docker run   --rm   -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
   	$kolla_swift_base_image swift-ring-builder \
    	/etc/kolla/config/swift/object.builder create 10 $replicas 1

for node in ${storage_nodes[@]}; do
    for i in $(seq 0 $index); do	
      docker run         --rm         -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
	      $kolla_swift_base_image swift-ring-builder \
    	      /etc/kolla/config/swift/object.builder add r1z1-${node}:6000/d${i} 1;
    done
done


echo "Generate Account Ring"
docker run   --rm   -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
   	$kolla_swift_base_image swift-ring-builder \
    	/etc/kolla/config/swift/account.builder create 10 $replicas 1

for node in ${storage_nodes[@]}; do
    for i in $(seq 0 $index); do
      docker run         --rm         -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
	      $kolla_swift_base_image swift-ring-builder \
    	      /etc/kolla/config/swift/account.builder add r1z1-${node}:6001/d${i} 1;
    done
done

echo " Generate Container Ring"
docker run   --rm   -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
   	$kolla_swift_base_image swift-ring-builder \
    	/etc/kolla/config/swift/container.builder create 10 $replicas 1

for node in ${storage_nodes[@]}; do
    for i in $(seq 0 $index); do
      docker run         --rm         -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
	      $kolla_swift_base_image swift-ring-builder \
    	      /etc/kolla/config/swift/container.builder add r1z1-${node}:6002/d${i} 1;
    done
done

echo "Rebalance Rings"
for ring in object account container; do
  docker run     --rm     -v /etc/kolla/config/swift/:/etc/kolla/config/swift/ \
  	  $kolla_swift_base_image swift-ring-builder \
    	  /etc/kolla/config/swift/${ring}.builder rebalance;
done
