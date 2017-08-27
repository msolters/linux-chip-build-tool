#!/bin/bash
# This is where custom business logic, configuration files and applications
# will be installed and/or prepared.
# Entry point: configure_rootfs()

BUILD_DIR="/home/vagrant"
OUTPUT_DIR="/vagrant"

TARGET_USER=chip
RESOURCES_DIR="$OUTPUT_DIR/resources"
BUILD_SCRIPTS_DIR="$OUTPUT_DIR/build-scripts"
ROOTFS_DIR="$BUILD_DIR/rootfs"
BUILDROOT_PATH="$BUILD_DIR/CHIP-buildroot"
UBOOT_PATH="$BUILDROOT_PATH/output/build/uboot-nextthing_2016.01_next"
CHIP_TOOLS_PATH="$BUILD_DIR/CHIP-tools"

# Helper function to execute a command as if it were running on the target
# by using qemu emulation
chroot_exec () {
  LC_ALL=C LANGUAGE=C LANG=C chroot $ROOTFS_DIR bash -c "$@"
}

# This ensures that sudo has the correct permissions to execute on the target.
# This is required or you're gonna have a bad time!
fix_sudo () {
  for FILE in /usr/bin/sudo /usr/lib/sudo/sudoers.so /etc/sudoers /etc/sudoers.d /etc/sudoers.d/README /var/lib/sudo
  do
    chown root:root $ROOTFS_DIR$FILE
    chmod 4755 $ROOTFS_DIR$FILE
  done
}

# This provides our target rootfs's rc.local.
write_rclocal () {
  echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0" | tee $ROOTFS_DIR/etc/rc.local
}

# Copy over interface and other networking files
install_network_config () {
  # Fix DNS resolution
  echo "nameserver 8.8.8.8" | tee $ROOTFS_DIR/etc/resolv.conf

  # Customize /etc/network/interfaces
  cp $RESOURCES_DIR/config/interfaces $ROOTFS_DIR/etc/network/interfaces
}

# An example of how to install precompiled software.
# In this case we're just decompressing nodejs into an installation target.
install_nodejs () {
  mkdir -p $ROOTFS_DIR/usr/local
  tar --strip-components 1 -xzf $RESOURCES_DIR/precompiled/node-v6.10.2-linux-armv7l.tar.gz -C $ROOTFS_DIR/usr/local/
}

# Ensure the target system is using python2.7
replace_python () {
  chroot_exec "ln -s /usr/bin/python2.7 /usr/bin/python"
}

# Incidental configuration of the customized rootfs
# This will vary depending on your multistrap config specifics and business
# logic.
# This demonstrates how to copy in resources such as config files, scripts, etc.
# to the target rootfs.
# Also demonstrates how to use the chroot_exec function to execute
# a command inside the target chroot itself.  Useful for performing pre-configuration
# that depends on network connection that the CHIP might not have out-of-the-box.
configure_rootfs () {

  # chroot into rootfs
  bash $BUILD_SCRIPTS_DIR/mount-chroot.sh -m

  # Some examples of installing custom user binaries or scripts.
  install_nodejs
  cp $RESOURCES_DIR/scripts/set_antenna $ROOTFS_DIR/usr/bin/set_antenna
  chmod +x $ROOTFS_DIR/usr/bin/set_antenna

  # Fix sudo & binary permissions
  #Required.
  chown root:root -R $ROOTFS_DIR/bin $ROOTFS_DIR/usr/bin $ROOTFS_DIR/usr/sbin
  fix_sudo

  # Complete Debian package installation and configuration
  # Required.
  chroot_exec "dpkg --configure -a"

  # Make sure we are using python 2.7 as default!
  replace_python

  # Network interface, DNS resolution, et cetera...
  install_network_config

  # Customize rc.local
  write_rclocal

  # Set password of root user
  # Required.
  echo "Set root password:"
  chroot_exec "passwd"

  # Create new non-root user
  # Ensure this user can use sudo
  chroot_exec "adduser $TARGET_USER"
  chroot_exec "usermod -aG sudo $TARGET_USER"

  bash $BUILD_SCRIPTS_DIR/mount-chroot.sh -u
}

configure_rootfs
