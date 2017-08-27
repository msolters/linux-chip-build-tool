#!/bin/bash

BUILD_DIR=/home/vagrant
VAGRANT_DIR=/vagrant
BUILD_SCRIPTS_DIR=$VAGRANT_DIR/build-scripts
cd $VAGRANT_DIR

# (1) Create the base rootfs using
bash $BUILD_SCRIPTS_DIR/create-rootfs.sh $VAGRANT_DIR/resources/debian-jessie.conf

# (2) Run the chroot configuration script
bash $BUILD_SCRIPTS_DIR/configure-chip.sh

# (3) Copy completed rootfs + uboot to output directory
bash $BUILD_SCRIPTS_DIR/export.sh

echo "Now you're ready to run bundle.sh and flash.sh!"
