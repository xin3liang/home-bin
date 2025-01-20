#!/bin/bash

disks="/dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1"
servers="server1 server5 server6"
mdt_parts_per_disk=${MDT_PARTS_PER_DISK:-1}
ost_parts_per_disk=${OST_PARTS_PER_DISK:-4}

# mdt config
c=0
lines=()
conf=mdt.conf
for p in $(seq $mdt_parts_per_disk); do
	for disk in $disks; do
		for server in $servers; do
			((c+=1))
			lines+=(mds${c}_HOST="$server")
			lines+=(MDSDEV$c="${disk}p$p")
		done
	done
done

echo "MDSCOUNT=\${MDSCOUNT:-$c}" > $conf
for line in ${lines[@]}; do
	echo $line >> $conf
done
sed -i -e 's/mds1_HOST/mds_HOST/' $conf
ls -l $conf

# ost config
c=0
lines=()
conf=ost.conf
for p in $(seq $((mdt_parts_per_disk+1)) $((mdt_parts_per_disk+ost_parts_per_disk)) ); do
	for disk in $disks; do
		for server in $servers; do
			((c+=1))
			lines+=(ost${c}_HOST="$server")
			lines+=(OSTDEV$c="${disk}p$p")
		done
	done
done

echo "OSTCOUNT=\${OSTCOUNT:-$c}" >$conf
for line in ${lines[@]}; do
	echo $line >> $conf
done
sed -i -e 's/ost1_HOST/ost_HOST/' $conf
ls -l $conf
