#!/bin/bash
# Here is where you can customize the build process to point to your own
# fork of CHIP-buildroot!

echo -e "\n Installing CHIP-buildroot"
if [ ! -d CHIP-buildroot ]; then
  git clone -b update-dtc-overlay-url https://github.com/msolters/CHIP-buildroot
else
  pushd CHIP-buildroot
  git pull
  popd
fi
