#/bin/bash
N=$1
POOL=$2

[[ -z $N ]] && N=24
[[ -z $POOL ]] && POOL=nvmeof
rbd_prefix=fio_test_image

for i in $(seq $N); do
        rbd=$POOL/${rbd_prefix}$i
        echo "Remove rbd $rbd"
        rbd rm $rbd
done
rbd -p $POOL disk-usage
