#!/bin/env bash

test -e logs || mkdir logs

test "$1" = "-c" && let CLEAR=1

BUILD_ROOTDIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

MAKEFLAGS=-j8

# cross compiler
COMPILER_PREFIX=arm-linux-gnueabihf-

# uboot needs gcc version < 5.0
UBOOT_COMPILER_PREFIX=arm-none-eabi-

. $BUILD_ROOTDIR/scripts/check_prereqs.sh
. $BUILD_ROOTDIR/scripts/build_uboot.sh
. $BUILD_ROOTDIR/scripts/build_kernel.sh
. $BUILD_ROOTDIR/scripts/build_RTL8723BS.sh
#$BUILD_ROOTDIR/scripts/build_packages.sh
. $BUILD_ROOTDIR/scripts/make_rootfs.sh
#$BUILD_ROOTDIR/scripts/flash_device.sh



