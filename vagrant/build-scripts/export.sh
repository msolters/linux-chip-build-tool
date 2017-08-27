#!/bin/bash
# This script bundles the rootfs into a tar archive that preserves permissions.
# This is then copied to the shared /vagrant folder.
# The compiled uboot loader is also copied to /vagrant.
#
# This tar MUST be decompressed as root on the host, or else file permissions
# will not be preserved and binaries such as sudo will not execute on the
# target device!
#
# This archive CANNOT be decompressed into the /vagrant folder, because
# the /vagrant folder will overwrite permissions in a way that will also break
# sudo and other binaries on the target device.

BUILD_DIR=/home/vagrant
VAGRANT_DIR=/vagrant
CHIP_BASE_IMAGE_DIR=$BUILD_DIR/chip-base-image

rm -rf $CHIP_BASE_IMAGE_DIR
mkdir -p $CHIP_BASE_IMAGE_DIR

# Create new rootfs archive
cp -pr $BUILD_DIR/rootfs $CHIP_BASE_IMAGE_DIR/rootfs

# Create new uboot archive
cp -pr $BUILD_DIR/CHIP-buildroot/output/build/uboot-nextthing_2016.01_next $CHIP_BASE_IMAGE_DIR/uboot

# Create new final archive
sudo rm -rf $VAGRANT_DIR/output
mkdir $VAGRANT_DIR/output
cd $CHIP_BASE_IMAGE_DIR
tar cfpz $VAGRANT_DIR/output/chip-base-image.tar.gz .
