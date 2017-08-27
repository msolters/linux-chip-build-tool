#!/bin/bash
# Brief
# This script automates mounting/cleaning up/entering a CHROOT based on your
# target CHIP image, rootfs/.

# Usage:
# mount-chroot.sh --mount
#   Mount the chroot, so it is ready for --join
# mount-chroot.sh --umount
#   Unmount the chroot & cleanup
# mount-chroot.sh --join
#   Enter the chroot (as current user)

ROOTFS_DIR=/home/vagrant/rootfs

MOUNT_OPERATION="$1"

case $MOUNT_OPERATION in
  -m|--mount)
    # We'll need this for ARM emulation in the CHROOT:
    cp /usr/bin/qemu-arm-static $ROOTFS_DIR/usr/bin
    mount -t proc nodev $ROOTFS_DIR/proc
    mount -o bind /dev $ROOTFS_DIR/dev
  ;;
  -u|--umount)
    rm $ROOTFS_DIR/usr/bin/qemu-arm-static
    umount -l $ROOTFS_DIR/proc && sudo umount -f $ROOTFS_DIR/proc
    umount -l $ROOTFS_DIR/dev && sudo umount -f $ROOTFS_DIR/dev
  ;;
  -j|--join)
    LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR
  ;;
esac

exit 0
