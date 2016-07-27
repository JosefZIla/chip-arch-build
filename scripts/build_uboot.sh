#!/bin/env bash
ALLFLAGS="$MAKEFLAGS CROSS_COMPILE=$UBOOT_COMPILER_PREFIX"

cd $BUILD_ROOTDIR/CHIP-u-boot
echo "Building uboot..."
{
  let CLEAR && make clean
  make $ALLFLAGS CHIP_defconfig 
  make $ALLFLAGS
} &>$BUILD_ROOTDIR/logs/uboot-build.log

test -e $BUILD_ROOTDIR/CHIP-u-boot/spl/sunxi-spl-with-ecc.bin || {
  echo "u-Boot build failed - see uboot-build.log"
  exit -1
}
