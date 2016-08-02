#!/bin/env bash
ALLFLAGS="$MAKEFLAGS CROSS_COMPILE=$COMPILER_PREFIX"

cd $BUILD_ROOTDIR/RTL8723BS
echo "Building RTL8723BS module (for wifi&bt) ..."
{
let CLEAR && make $ALLFLAGS clean
for i in debian/patches/0*; do  echo $i; patch -p 1 <$i ; done
make $ALLFLAGS CONFIG_PLATFORM_ARM_SUNxI=y ARCH=arm -C $BUILD_ROOTDIR/CHIP-linux M=$PWD CONFIG_RTL8723BS=m 
} &>$BUILD_ROOTDIR/logs/RTL8723BS-build.log

test -e $BUILD_ROOTDIR/RTL8723BS/8723bs.ko || {
  echo "RTL8723 build failed - see RTL8723BS-build.log"
  exit -1
}

