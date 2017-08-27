#!/bin/bash
# These are tools provided by NTC for packaging our target rootfs as an
# image that can be flashed to the CHIP Pro's NAND drive.

echo -e "\n Installing sunxi-tools"
if [ -d sunxi-tools ]; then
  rm -rf sunxi-tools
fi
git clone https://github.com/linux-sunxi/sunxi-tools
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
    rm /usr/local/bin/${BIN}
  fi
  ln -s $PWD/${BIN} /usr/local/bin/${BIN}
done
popd

git clone https://github.com/nextthingco/chip-mtd-utils
pushd chip-mtd-utils
git checkout by/1.5.2/next-mlc-debian
make
make install
popd

echo -e "\n Installing CHIP-tools"
if [ -d CHIP-tools ]; then
  pushd CHIP-tools
  git pull
  popd
else
  git clone https://github.com/NextThingCo/CHIP-tools.git
fi
