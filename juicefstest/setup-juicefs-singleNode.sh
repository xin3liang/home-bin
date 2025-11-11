#!/bin/bash -e

cmd=$1
arg1=$2
arg2=$3
arg3=$4

fs_name=jfs1
fs_type=xfs
cache_mount_dir=~/cache/$fs_type/jfs
sqlite_dir=$cache_mount_dir/sqlite3_db
cache_dir=$cache_mount_dir/cache

META_DB_URL=sqlite3://$sqlite_dir/$fs_name.db
BUCKET_URL=$cache_mount_dir/file_data
MOUNT_DIR=~/mount-fs/jfs/$fs_name
test_dir=$MOUNT_DIR/fio
ACCESS_KEY=minioadmin
SECRET_KEY=minioadmin

umount_cache_dir()
{
	echo "Umount cache dir: $cache_mount_dir ..."
	while umount -f $cache_mount_dir; do
		echo "Umount $cache_mount_dir again"
	done
	rm -rf $cache_mount_dir
}

prepare()
{
	echo "Prepare cache dir ..."
	umount_cache_dir
	if [[ -n $arg1 ]]; then
		vg=juicefsCache
		lv=dataCache

		dmsetup remove $vg-$lv || true
		lvremove -f $vg/$lv || true
		vgremove -f $vg || true

		disks=${arg1//,/ }
		diskNum=$(echo $disks|wc -w)
		for disk in $disks; do
			disk=/dev/$disk
			wipefs -af $disk
			pvcreate -f $disk
			pvs+=" $disk"
		done

		vgcreate $vg $pvs
		lvcreate -y --stripes $diskNum -l 100%FREE --name $lv $vg
		# format lv disk
		lv_path=$(lvs -o lv_path --noheadings $vg/$lv)
		mkfs.$fs_type $lv_path

		rm -rf $cache_mount_dir && mkdir -p $cache_mount_dir
		mount $lv_path $cache_mount_dir
		df -h| grep -i $cache_mount_dir
		dperf $cache_mount_dir -v -i 64
	else
		echo "No disks for cache, will disable cache mount: '--cache-size=0' !!"
	fi
}

format_juicefs()
{
	echo "Format juicefs ..."
	if [[ -z $arg1 ]]; then
		storage="file"
	else #
		storage=$arg1
	fi

	if [[ -n $arg2 ]]; then
		META_DB_URL=$arg2
	else
		mkdir -p $sqlite_dir
	fi

	if [[ "$storage" != "file" ]]; then
		BUCKET_URL=$arg3
		extra_opts+="  --access-key $ACCESS_KEY  --secret-key $SECRET_KEY"
	else
		rm -rf $BUCKET_URL 
	fi

	## format juicefs
	cmd="juicefs format --storage $storage --bucket $BUCKET_URL --trash-days 0  $META_DB_URL $fs_name --force $extra_opts"
	echo $cmd; eval $cmd
}

mount_juicefs()
{
	echo "Mount juicefs ... "
	cpu_count=0
	if [[ $arg1 =~ "redis:" ]]; then
		META_DB_URL=$arg1
		numas=${arg2//,/ }
		cmd_head+="$arg3 "
	else
		numas=${arg1//,/ }
		cmd_head+="$arg2 "

	fi

	if [[ -n $numas ]]; then
		for numa in $numas; do
			cpu_lists=$(lscpu|grep node$numa|awk '{print $4}')
			cpu_lists=${cpu_lists//,/ }
			for list in $cpu_lists; do
				cpus=$(echo $list|awk -F'-' '{print $2-$1+1}')
				cpu_count=$((cpu_count + cpus))
			done
		done
		numa_list=${numas// /,}
		cmd_head+="GOMAXPROCS=$cpu_count numactl --cpunodebind=$numa_list --membind=$numa_list "
	else
		cpu_lists=$(lscpu|grep -E "NUMA node[0-9]"|awk  '{print $4}')
		cpu_lists=${cpu_lists//,/ }
		for list in $cpu_lists; do
			cpus=$(echo $list|awk -F'-' '{print $2-$1+1}')
			cpu_count=$((cpu_count + cpus))
		done
	fi
	rm -rf $MOUNT_DIR && mkdir -p $MOUNT_DIR
	opts="-d $META_DB_URL $MOUNT_DIR --buffer-size=20480 --max-uploads $cpu_count"
#	[[ "$(arch)" == "aarch64" ]] && opts+=" --max-fuse-io 1M"
	if mountpoint -q $cache_mount_dir; then
		cache_size=$(df -lm --output=size $cache_mount_dir |tail -n 1)
		cache_size=$(echo $cache_size)

 		opts+=" --cache-dir=$cache_dir --cache-size=$cache_size"
     	else
		opts+=" --cache-size=0"
		echo "No cache dir, will disable cache mount: '--cache-size=0' !!"
	fi
	cmd="$cmd_head juicefs mount $opts"
	echo $cmd; eval $cmd
	mkdir -p $test_dir
}

umount_juicefs()
{
	echo "Umount juicefs ..."
	juicefs umount $MOUNT_DIR
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
	umount_juicefs
	setup_juicefs
}

cleanup_juicefs()
{
	echo "Clean up juicefs ..."
	if [[ -n $arg1 ]]; then
		META_DB_URL=$arg1
	fi
	if [[ "$arg1" == "all" ]] || [[ "$arg2" == "all" ]]; then
		(juicefs rmr $MOUNT_DIR/* 2>&1 || true) > /dev/null
	fi
	(juicefs gc --delete $META_DB_URL 2>&1)
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
	extra_opts=""
	if [[ -z $arg1 ]]; then
		storage="file"
	else
		storage=$arg1
		extra_opts+="  --access-key $ACCESS_KEY  --secret-key $SECRET_KEY"
	fi
	if [[ -n $arg2 ]]; then
		BUCKET_URL=$arg2
	fi
	echo "Do objbench for backend: $BUCKET_URL ..."
	cmd="juicefs objbench --storage $storage $BUCKET_URL --skip-functional-tests --threads $(nproc) $extra_opts"
	echo $cmd; eval $cmd
}

case "$cmd" in
	"prepare")
		prepare
		;;
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
		umount_juicefs || true
		umount_cache_dir || true
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
		echo "Please input arg: prepare [disk1,disk2,..], format [storage metadb_url bucket_url], mount [metadb_url] [ numa_num cmdheads], setup, resetup, cleanup [metadb_url] [all], umount, umount_all, remount, objbench [storage bucket_url]"
		;;
esac

