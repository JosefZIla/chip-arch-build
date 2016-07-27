#!/bin/env bash

cd $BUILD_ROOTDIR
test -e rootfs || mkdir rootfs

let CLEAR && rm -rf rootfs/* ubi.img ubifs.img ubi.img.sparse ArchLinuxARM-armv7-latest.tar.gz

echo "Downloading generic armv7 image"
wget -nc http://de7.mirror.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz

echo "Entering fakeroot and making image"
fakeroot bash &>$BUILD_ROOTDIR/logs/create_rootfs.log <<FAKEROOT_END
set -x
# unpack image
tar xfz ArchLinuxARM-armv7-latest.tar.gz -C rootfs
# uninstall kernel
pacman -R -brootfs/var/lib/pacman -rrootfs linux-armv7 linux-firmware --noconfirm
rm -rf rootfs/lib/modules/*
# install additional packages
pacman -S --arch=armv7h -brootfs/var/lib/pacman -rrootfs dialog wpa_supplicant links --noconfirm
# install kernel
cp $BUILD_ROOTDIR/CHIP-linux/arch/arm/boot/zImage rootfs/boot
# install dtbs
mkdir rootfs/boot/dtbs
cp $BUILD_ROOTDIR/CHIP-linux/arch/arm/boot/dts/*.dtb rootfs/boot/dtbs
# install kernel modules
cd $BUILD_ROOTDIR/CHIP-linux
make INSTALL_MOD_PATH=../rootfs/ modules_install
# install kernel firmware
make INSTALL_FW_PATH=../rootfs/lib/firmware firmware_install
# install kernel headers
make INSTALL_HDR_PATH=../rootfs/usr headers_install
# install RTL8723BS
cd $BUILD_ROOTDIR/RTL8723BS
make -C $BUILD_ROOTDIR/CHIP-linux M=$PWD/RTL8723BS INSTALL_MOD_PATH=../rootfs/ modules_install
# configure journalctl to use volatile storage
cd $BUILD_ROOTDIR
sed -i 's/.\?Storage=.*/Storage=volatile/' rootfs/etc/systemd/journald.conf
# load module for gadget_serial (console on power usb)
echo g_serial >rootfs/etc/modules-load.d/gadget_serial.conf
# start tty on gadget_serial
ln -s /usr/lib/systemd/system/getty@.service rootfs/etc/systemd/system/getty.target.wants/getty@ttyGS0.service
mkfs.ubifs -m 16384 -e 0x1f8000 -c 2000 -r rootfs ubifs.img
FAKEROOT_END
ubinize -o ubi.img -m 16384 -p 2MiB -s 16384 configs/ubinize.cfg
img2simg ubi.img ubi.img.sparse 2097152
