#!/bin/bash -e



disks="nvme0n1 nvme1n1 nvme2n1 nvme3n1"
fs_type=xfs
prefix_path=~/mount-fs/$fs_type/data

diskNum=$(echo $disks|wc -w)

umount_dirs()
{
	# umount
	for i in $(seq $diskNum); do
		path=${prefix_path}$i
		echo "Process umount $path ..."
		umount $path || true
		rm -rvf $path
	done
	dmsetup remove_all
}

mount_dirs()
{
	n=1
	for disk in $disks; do
		disk=/dev/$disk
		path=${prefix_path}$n
		echo "Process mount $disk .."

		wipefs -af $disk
		mkdir -p $path &&
		wipefs -af $disk &&
		mkfs.$fs_type $disk &&
		mount $disk $path
		((n+=1))
	done
	df -h
}

setup_minio()
{
	# setup minio
	for host in $hosts; do
		paths+=" http://$host/${prefix_path}{1...4}"
	done
 	cmd="MINIO_STORAGE_CLASS_STANDARD=EC:0 minio server --console-address :9001 $paths"
	echo $cmd; eval $cmd

}

if [[ $1 == "mount" ]]; then
	umount_dirs
	mount_dirs
fi

if [[ $1 == "umount" ]]; then
	umount_dirs
	exit 0
fi

if [[ $1 == "setup" ]]; then
	hosts="${2//,/ }"
	[[ -z $hosts ]] && hosts="$(hostname)"
	setup_minio
	exit 0
fi

# test dirs performance
cmd="dperf ${prefix_path}{1..${diskNum}} -v -i 16"
eval $cmd
