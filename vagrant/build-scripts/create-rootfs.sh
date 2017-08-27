#!/bin/bash
# Brief
# This script will create a bootable custom Linux image that can be flashed to
# a CHIP Pro using the command line utilities in CHIP-tools.

# Usage:
# sh buildroot-rootfs.sh multistrap.conf
#     Where multistrap.conf is the relative path to the multistrap config
#     file defining what extra packages you want your target OS to contain.

MULTISTRAP_CONF_FILE="$1"
BUILD_DIR="/home/vagrant"
OUTPUT_DIR="/vagrant"
BUILDROOT_PATH="$BUILD_DIR/CHIP-buildroot"
ROOTFS_DIR="$BUILD_DIR/rootfs"

# This compiles CHIP-buildroot and decompresses the resulting rootfs
# into the CHIP-buildroot/buildroot-rootfs directory for later reference.
# Note: This can take a LONG time! Even on a powerful machine.
compile_chip_buildroot () {
  cd $BUILDROOT_PATH
  make chippro_defconfig
  make
  rm -rf buildroot-rootfs
  mkdir buildroot-rootfs
  tar -xf $BUILDROOT_PATH/output/images/rootfs.tar -C ./buildroot-rootfs
}

# Copy over relevant kernel and kernel modules for the CHIP Pro board
# from the CHIP-buildroot rootfs
copy_boot_modules () {
  cp -r $BUILDROOT_PATH/buildroot-rootfs/boot/* $ROOTFS_DIR/boot/
  cp -r $BUILDROOT_PATH/buildroot-rootfs/lib/modules $ROOTFS_DIR/lib/
}

# Create a rootfs using multistrap and clean any old data
create_rootfs () {
  umount -l $ROOTFS_DIR/proc && umount -f $ROOTFS_DIR/proc
  rm -rf $OUTPUT_DIR/rootfs.tar $ROOTFS_DIR
  multistrap -f $MULTISTRAP_CONF_FILE -d $ROOTFS_DIR
  copy_boot_modules
  sudo chown -R $USER:$USER $ROOTFS_DIR
}

compile_chip_buildroot
create_rootfs
