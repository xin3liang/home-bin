#!/bin/bash                                                                                                                                                                        
KERNEL_OUT=~/work/kernel/out
BUILD_TARGET="Image hisilicon/hip05-d02.dtb hisilicon/hip06-d03.dtb"
CROSS_TOOLCHAIN=aarch64-linux-gnu-

#set -x

make -p ${KERNEL_OUT} &&
make mrproper &&

## build kernel testing
make ARCH=arm64 O=${KERNEL_OUT} defconfig &&
make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN O=${KERNEL_OUT} \
${BUILD_TARGET} -j40 

#set +x
