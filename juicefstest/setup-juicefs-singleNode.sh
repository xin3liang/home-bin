#!/bin/bash -e

cmd=$1
arg1=$2
arg2=$3

fs_name=jfs2
#NVME=/dev/nvme3n1
NVME=/dev/nvme1n1
nvme_mount_dir=/root/juicefstest/jfs
sqlite_dir=$nvme_mount_dir/sqlite3_db
cache_dir=$nvme_mount_dir/cache

META_DB_URL=sqlite3://$sqlite_dir/$fs_name.db
BUCKET_URL=$nvme_mount_dir/file_data
MOUNT_DIR=/root/juicefstest/mount-fs
test_dir=$MOUNT_DIR/fio

format_juicefs()
{
	echo "Format juicefs ..."
	## format nvme disk
	wipefs -a $NVME && mkfs.ext4 $NVME
	rm -rf $nvme_mount_dir && mkdir -p $nvme_mount_dir
	mount $NVME $nvme_mount_dir
	mkdir -p $sqlite_dir

	## format juicefs
	juicefs format --storage file --bucket $BUCKET_URL --trash-days 0  $META_DB_URL $fs_name --force
}

mount_juicefs()
{
	echo "Mount juicefs ... "
	cpu_count=0
	cmd_head=""
	if [[ -n $arg2 ]]; then
		cmd_head+="$arg2 "
	fi
	if [[ -n $arg1 ]]; then
		numas=${arg1//,/ }
		for numa in $numas; do
			cpu_lists=$(lscpu|grep node$numa|awk '{print $4}')
			cpu_lists=${cpu_lists//,/ }
			for list in $cpu_lists; do
				cpus=$(echo $list|awk -F'-' '{print $2-$1+1}')
				cpu_count=$((cpu_count + cpus))
			done
		done
		cmd_head+="GOMAXPROCS=$cpu_count numactl --cpunodebind=$arg1 --membind=$arg1 "
	else
		cpu_lists=$(lscpu|egrep "NUMA node[0-9]"|awk  '{print $4}')
		cpu_lists=${cpu_lists//,/ }
		for list in $cpu_lists; do
			cpus=$(echo $list|awk -F'-' '{print $2-$1+1}')
			cpu_count=$((cpu_count + cpus))
		done
	fi
	rm -rf $MOUNT_DIR && mkdir -p $MOUNT_DIR
	cmd="$cmd_head juicefs mount -d $META_DB_URL $MOUNT_DIR --cache-dir=$cache_dir --buffer-size=1024M --max-uploads $cpu_count"
	echo "eval $cmd"
	mkdir -p $test_dir
}

umount_juicefs()
{
	echo "Umount juicefs ..."
	juicefs umount $MOUNT_DIR
}

umount_all()
{
	echo "Umount all ..."
	umount_juicefs || true
	umount $nvme_mount_dir || true
}

setup_juicefs()
{
	echo "Setup juicefs ..."
	format_juicefs
	mount_juicefs
}

resetup_juicefs()
{
	echo "Resetup juicefs ..."
	umount_all
	setup_juicefs
}

cleanup_juicefs()
{
	echo "Clean up juicefs ..."
	(juicefs rmr $test_dir/* 2>&1 || true) > /dev/null
	(juicefs gc --delete $META_DB_URL 2>&1) > /dev/null
	(sync && echo 3 > /proc/sys/vm/drop_caches) > /dev/null
       	free -g|grep Mem; df -h| grep -i juicefs
}

remount_juicefs()
{
	echo "Remount juicefs ..."
	cleanup_juicefs
	umount_juicefs
	mount_juicefs
}

juicefs_objbench()
{
	echo "Do objbench for backend: $BUCKET_URL ..."
	cleanup_juicefs
	juicefs objbench --storage file $BUCKET_URL --skip-functional-tests --threads $(nproc)
}

case "$cmd" in
	"format")
		format_juicefs
		;;
	"mount")
		mount_juicefs
		;;
	"setup")
		setup_juicefs
		;;
	"resetup")
		resetup_juicefs
		;;
	"umount")
		umount_juicefs
		;;
	"umount_all")
		umount_all
		;;
	"remount")
		remount_juicefs
		;;
	"objbench")
		juicefs_objbench
		;;
	"cleanup")
		cleanup_juicefs
		;;
	*)
		echo "Please input arg: format, mount [numa_num], setup, resetup, cleanup, umount, remount, umount_all, objbench"
		;;
esac

