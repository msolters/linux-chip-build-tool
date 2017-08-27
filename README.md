# Automate Custom Linux Images for the CHIP Pro
This software provides a convenient and highly automated system by which you can build and flash your own custom Linux OS for the CHIP Pro.  While NTC provides other solutions, such as GadgetOS, some end users will inevitably want or more often need to build their own Linux from scratch.

While NTC's `buildroot` and `CHIP-tools` provide a working kernel, what if you need to have a set of other packages such as `hostapd`, `nano`, etc. on board the CHIP by default? What if you want the full Debian experience; how can you strip it down to fit on the CHIP Pro's tiny NAND drive?  How can you pre-build an image that has all your target's configuration already complete out-of-the-box?  What about installing custom binaries, such as NodeJS tarballs?  This utility addresses all of this in a convenient, hackable and scriptable fashion.

All building takes place inside a virtual Vagrant environment, which helps protect your development machine from being damaged or by the complexities of debootstrapping, emulating and configuration a chroot.  It also facilitates rapid prototyping -- if you mess anything up you can just instantly reset your build environment.  Since Vagrant depends on VirtualBox to fully virtualize the environment's underlying kernel, the build can be executed on any host (Windows, Mac, Linux).

Flashing CLI utilities from NTC are also provided in the `/flashing` directory.  It is recommended to flash on a Linux host.  Flashing on Windows or Mac using these scripts doesn't seem reliable.

# Quick Start
## Building
See `vagrant/README.md`.

## Flashing
See `flashing/README.md`.
