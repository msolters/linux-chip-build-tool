#!/bin/bash
# Brief
# Creates a final NAND image (directory ready-to-flash) from the rootfs.tar

HERE="$PWD"
OUTPUT_DIR="$HERE/../vagrant/output"
CHIP_TOOLS_PATH="$HERE/CHIP-tools"
ROOTFS_TAR_PATH="$OUTPUT_DIR/rootfs.tar"
UBOOT_PATH="$OUTPUT_DIR/uboot"

# By default, this tool generates a tarball called
# vagrant/output/chip-base-image.tar.gz
# The reason for this is to facilitate creating a firmware build process
# that is separate from the actual flashing process.
# To flash the OS manually, some of the data must be extracted and recompressed.
reconstitute_output () {
  # First, unpack the output tarball
  sudo tar fxz $OUTPUT_DIR/chip-base-image.tar.gz -C $OUTPUT_DIR

  # Then, re-tar rootfs
  cd $OUTPUT_DIR/rootfs
  sudo tar cfp $ROOTFS_TAR_PATH .

  # Make sure everything in this output folder is deletable!
  sudo chown -R $USER:$USER $OUTPUT_DIR
}

# rootfs.tar -> NAND image
build_rootfs () {
  cd $HERE
  sudo rm -rf $HERE/nand-image
  sudo bash "$CHIP_TOOLS_PATH/chip-create-nand-images.sh" "$UBOOT_PATH" "$ROOTFS_TAR_PATH" "$HERE/nand-image"
  sudo chown -R $USER:$USER $HERE/nand-image
}

reconstitute_output
build_rootfs
