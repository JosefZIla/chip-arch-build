#!/bin/bash

REQUIRED_PROGRAMS=(
   make
   git
   dtc
   fastboot
   sunxi-fel
   ubinize
   mkfs.ubifs
   img2simg
   ${COMPILER_PREFIX}gcc
   ${UBOOT_COMPILER_PREFIX}gcc
   patch
   mkimage
)

for prog in ${REQUIRED_PROGRAMS[@]}; do
  echo "checking $prog..."
  hash $prog || {
    echo "ERROR: $prog not found!"
    exit -1
  }
done

echo "all required programs present"
