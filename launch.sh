#!/bin/bash -xe

#CDROM_IMG=~/work/estuary/submodules/build-ubuntu/out/release/master/ubuntu/mini.iso
CDROM_IMG=~/work/estuary/submodules/build-debian/out/release/master/debian/mini.iso
HDA_IMG=hda.img

make_cdrom_arg()
{
        echo "-drive file=$1,id=cdrom,if=none,media=cdrom" \
             "-device virtio-scsi-device -device scsi-cd,drive=cdrom"
}

make_hda_arg()
{
        echo "-drive if=none,file=$1,id=hd0" \
             "-device virtio-blk-device,drive=hd0"
}

HDA_ARGS=`make_hda_arg $HDA_IMG`
if [ $# -eq 1 ]; then
        case $1 in
            install)
                CDROM_ARGS=`make_cdrom_arg $CDROM_IMG`
            ;;
            *)
                CDROM_ARGS=""
            ;;
        esac
fi

sudo qemu-system-aarch64 -smp 64 -m 1024 -cpu host -M virt,gic_version=3 -nographic -enable-kvm \
                    -pflash flash0.img -pflash flash1.img \
                    $CDROM_ARGS $HDA_ARGS -netdev user,id=eth0 \
                    -device virtio-net-device,netdev=eth0
