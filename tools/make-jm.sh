#!/bin/bash
    
    echo "Select the android version of the build: "
    echo ">1 - (4.1.2)"
    echo " 2 - (4.1.1)"
    read selected

    ANDVER="4.1.2"

    case $selected in
    1) ANDVER='4.1.2' ;;
    2) ANDVER='4.1.1' ;;
    esac
    
    echo $andversion

    DEFCONFIG=tuna_defconfig
    ARCH="ARCH=arm"
    DIR=..
    ANDPATH='4.1.2'
    RAMDIR=$DIR/tools/ramdisk
    TOOLS=$DIR/tools
    COMPILE="CCOMPILER=$TOOLS/arm-eabi-4.4.3/bin/arm-eabi-"
    KERNEL=$DIR/$ANDVER/arch/arm/boot/zImage
    
    KBUILD_BUILD_VERSION="JourneymanMod-Kernel-V3"
    KBUILD_BUILD_USER=""
    KBUILD_BUILD_HOST=""
    cd ..
    cd $ANDVER
    export KBUILD_BUILD_VERSION
    export KBUILD_BUILD_USER
    export KBUILD_BUILD_HOST
    export $COMPILE
    export $ARCH
    make ARCH=arm $DEFCONFIG
    make ARCH=arm CROSS_COMPILE=$CCOMPILER zImage
    if [ -f $KERNEL ]; then
	echo
	echo "Kernel has been compiled ($ANDVER)!"
	echo
    else
	echo
	echo "Kernel did not compile, check for errors"
	echo
	exit
    fi
    cd ..
    cd tools
    $TOOLS/mkbootimg --kernel $KERNEL --ramdisk $RAMDIR/$ANDVER.gz --cmdline '' --base 80000000 --pagesize 2048 -o boot.img
    
    echo
    echo "Boot.img created ok"
    echo