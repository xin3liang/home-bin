#!/bin/bash

disks="/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1"
#disks="/dev/nvme0n1"

for disk in $disks; do
	echo "Partition $disk "
	dmsetup remove_all
	wipefs -a $disk
	parted $disk mklabel gpt
	parted -a optimal $disk mkpart mdt 0% 20%

	parted -a optimal $disk mkpart ost 20% 40%
	parted -a optimal $disk mkpart ost 40% 60%
	parted -a optimal $disk mkpart ost 60% 80%
	parted -a optimal $disk mkpart ost 80% 100%
	parted $disk print free
done
