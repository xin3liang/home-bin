#!/bin/bash                                                                                                                                                                        

## params
version_prefix="test"

if [ $# -ge 1 ]; then
    version_prefix=$1
fi


OUT=~/work/kernel/out
KERNEL_BOOT_DIR=arch/arm64/boot
CP=cp
DEST=~/tftp

CROSS_TOOLCHAIN=aarch64-linux-gnu-
COFNIG_FILE=~/config-4.16.0-estuary.5.aarch64

export LOCALVERSION="-${version_prefix}-`date +%F`"
export KBUILD_DEBARCH=arm64
# targets: bindeb-pkg binrpm-pkg INSTALL_MOD_STRIP=1 Image modules INSTALL_MOD_PATH=${OUT} modules_install"
#BUILD_TARGETS="Image modules"
BUILD_TARGETS="binrpm-pkg INSTALL_MOD_STRIP=1"
CP_TARGETS="${KERNEL_BOOT_DIR}/Image"

set -x

## kernel .config compile
#cp ${COFNIG_FILE} ${OUT}/.config	
# CONFIG: oldconfig defconfig estuary_defconfig
CONFIG="oldconfig"

make ARCH=arm64 O=${OUT} ${CONFIG}

#	./scripts/kconfig/merge_config.sh -m ${COFNIG_FILE1} \
#		${COFNIG_FILE2} ${COFNIG_FILE3}\
#	mv -f .config ${OUT}/.merged.config &&
#	make ARCH=arm64 O=${OUT} KCONFIG_ALLCONFIG=${OUT}/.merged.config \
#		alldefconfig


## kernel compile
if [ $? -eq 0 ]; then 
	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN O=${OUT} ${FLAGS} \
		${BUILD_TARGETS} -j80 &&
	cd ${OUT} &&
	${CP} -r ${CP_TARGETS} ${DEST}
fi

set +x
