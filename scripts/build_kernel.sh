#!/bin/env bash
ALLFLAGS="$MAKEFLAGS"

cd $BUILD_ROOTDIR/CHIP-linux
echo "Building kernel ..."
{
  cp ../configs/kernel_config .config
  let CLEAR && make clean 
  make $ALLFLAGS
} &>$BUILD_ROOTDIR/logs/kernel-build.log

test -e $BUILD_ROOTDIR/CHIP-linux/arch/arm/boot/zImage || {
  echo "Kernel build failed - see kernel-build.log"
  exit -1
}

