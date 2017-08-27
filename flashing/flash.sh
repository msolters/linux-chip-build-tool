#!/bin/bash
# Flash the NAND image stored by new-image/ to any attached FEL device.

HERE="$PWD"
CHIP_TOOLS_PATH="$HERE/CHIP-tools"

bash $CHIP_TOOLS_PATH/chip-flash-nand-images.sh $HERE/nand-image
