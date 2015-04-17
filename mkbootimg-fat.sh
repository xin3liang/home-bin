#!/bin/bash                                                                                                                                                                        
build=debian  #android or debian
ip=192.168.1.227

## kernel .config compile
if [ "$build" = "debian" ]; then
	CROSS_TOOLCHAIN=aarch64-linux-gnu-
	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN defconfig
elif [ "$build" = "android" ]; then
	CROSS_TOOLCHAIN=aarch64-linux-android-
	./scripts/kconfig/merge_config.sh -m arch/arm64/configs/defconfig  android/configs/android-base.cfg && \
	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN KCONFIG_ALLCONFIG=.config alldefconfig
else
	echo "error build not 'android' or 'debian'!!"
	exit 1
fi

## kernel compile
if [ $? -eq 0 ]; then 
	make ARCH=arm64 CROSS_COMPILE=$CROSS_TOOLCHAIN Image hi6220-hikey.dtb -j40 && \
	scp -r arch/arm64/boot/Image arch/arm64/boot/dts/hi6220-hikey.dtb \
	liuxl@${ip}:/home/liuxl/work/img/${build}
fi
