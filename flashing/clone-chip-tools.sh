#!/bin/bash

echo -e "\n Cloning CHIP-tools"
git clone http://github.com/nextthingco/CHIP-tools

echo -e "\n Installing sunxi-tools"
if [ -d sunxi-tools ]; then
  rm -rf sunxi-tools
fi
git clone http://github.com/linux-sunxi/sunxi-tools
pushd sunxi-tools
make
make misc
SUNXI_TOOLS=(sunxi-bootinfo
sunxi-fel
sunxi-fexc
sunxi-nand-part
sunxi-pio
pheonix_info
sunxi-nand-image-builder)
for BIN in ${SUNXI_TOOLS[@]};do
  if [[ -L /usr/local/bin/${BIN} ]]; then
    sudo rm /usr/local/bin/${BIN}
  fi
  sudo ln -s $PWD/${BIN} /usr/local/bin/${BIN}
done
popd
