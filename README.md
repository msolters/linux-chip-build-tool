# Automate Custom Linux Images for the CHIP Pro
This software provides a convenient and highly automated system by which you can build and flash your own custom Linux OS for the CHIP Pro.  While NTC provides other solutions, such as GadgetOS, some end users will inevitably want or more often need to build their own Linux from scratch.

Flashing CLI utilities from NTC are also repackaged here in the `/flashing` directory.  It is recommended to flash on a Linux host.  Flashing on Windows or Mac using these scripts doesn't seem reliable.

# Quick Start
Some quick vocab:

*  `Target OS`: the Linux image we want to create for the CHIP Pro
*  `Development Host`: the localhost you are working on to run this build tool

First, clone this repository to your development host!
```
git clone http://github.com/msolters/linux-chip-build-tool
cd ./linux-chip-build-tool
```

## Building
See [`vagrant/README.md`](https://github.com/msolters/linux-chip-build-tool/tree/master/vagrant).

## Flashing
See [`flashing/README.md`](https://github.com/msolters/linux-chip-build-tool/tree/master/flashing).

# Why?
NTC's `buildroot` and `CHIP-tools` provide a basic working kernel for the CHIP Pro.  But...
*  What if you need to have a set of other packages such as `hostapd`, `nano`, etc. on board the CHIP by default?
*  What if you want the full Debian experience; how can you strip it down to fit on the CHIP Pro's tiny NAND drive?
*  How can you pre-build an image that has all your target's configuration already complete out-of-the-box?
*  What about installing custom binaries, such as NodeJS tarballs?

This utility addresses all of these problems and more in a convenient, portable, and scriptable fashion.

Target OS building takes place inside a Vagrant virtual environment, which helps protect your development machine from being damaged by the complexities of debootstrapping, emulating and configuration a chroot.  It also facilitates rapid prototyping -- if you mess anything up you can just instantly reset your build environment, but retain your build scripts.  Since Vagrant depends on VirtualBox to fully virtualize the environment's underlying kernel, the build can be executed on any development host (Windows, Mac, Linux).
