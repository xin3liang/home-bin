#!/bin/bash                                                                                                                                                                        
BUILD=debian  # debian, oe, rp or aosp
IP=192.168.1.127
USER=liuxl
OUT=~/work/kernel/out
AOSP_SRC=~/work/android/hikey-devel-master
BOOT_IMG=out/target/product/hikey/boot_fat.uefi.img

set -x

## kernel .config compile
CROSS_TOOLCHAIN=aarch64-linux-gnu-
if [ "$BUILD" = "rp" ]; then
	IP=192.168.1.107
	make ARCH=arm64 O=${OUT} defconfig

	#./scripts/kconfig/merge_config.sh -m arch/arm64/configs/defconfig \
	#arch/arm64/configs/distro.config && 
	#mv -f .config ${OUT}/.merged.config &&
	#make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN O=${OUT} \
	#KCONFIG_ALLCONFIG=${OUT}/.merged.config alldefconfig

	CP=scp
	DEST=${USER}@${IP}:ftp
	DTB="hisilicon/hip05-d02.dtb"
	DTB2="hisilicon/hip06-d03.dtb"
	BUILD_TARGETS="Image $DTB $DTB2"
	CP_TARGETS="arch/arm64/boot/Image arch/arm64/boot/dts/$DTB arch/arm64/boot/dts/$DTB2"
elif [ "$BUILD" = "debian" ] || [ "$BUILD" = "oe" ]; then
	FLAGS=
	export LOCALVERSION="-linaro-hikey"
	#make ARCH=arm64 O=${OUT} defconfig

	./scripts/kconfig/merge_config.sh -m arch/arm64/configs/defconfig \
	arch/arm64/configs/distro.config && 
	mv -f .config ${OUT}/.merged.config &&
	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN O=${OUT} \
	KCONFIG_ALLCONFIG=${OUT}/.merged.config alldefconfig


	CP=scp
	DEST=${USER}@${IP}:work/img/${BUILD}
	DTB="hisilicon/hi6220-hikey.dtb"
	BUILD_TARGETS="Image $DTB" # modules INSTALL_MOD_PATH=$OUT modules_install"
	CP_TARGETS="arch/arm64/boot/Image arch/arm64/boot/dts/$DTB"
elif [ "$BUILD" = "aosp" ]; then
	#FLAGS="KCFLAGS=-fno-pic"

	CROSS_TOOLCHAIN=aarch64-linux-android-
	make ARCH=arm64 O=${OUT} hikey_defconfig
	CP=cp
	DEST=${AOSP_SRC}/device/linaro/hikey-kernel
	DTB="hisilicon/hi6220-hikey.dtb"
else
	echo "error build not 'android' or 'debian'!!"
	exit 1
fi

## kernel compile
if [ $? -eq 0 ]; then 
	# modules INSTALL_MOD_PATH=$OUT modules_install hisilicon/ 

	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN O=${OUT} ${FLAGS} \
		${BUILD_TARGETS} -j40 &&
	cd ${OUT} &&
	${CP} -r ${CP_TARGETS} ${DEST}

	if [ "$BUILD" = "aosp" ] && [ $? -eq 0 ]; then 
		cd ${AOSP_SRC} &&
		. ./build/envsetup.sh &&
		lunch hikey-userdebug &&
		make ${BOOT_IMG} &&
		scp ${BOOT_IMG} ${USER}@${IP}:work/img/${BUILD}
	fi
fi

set +x
