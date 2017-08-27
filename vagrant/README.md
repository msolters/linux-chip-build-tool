# Building
We use Vagrant as the build environment the CHIP Pro's target OS.  Inside the Vagrant environment we will:

*  Compile a kernel with necessary modules using `buildroot`
*  Construct a rootfs with desired upstream packages using `multistrap`
*  Perform post-build system emulation, configuration and setup using `build-scripts/configure-chip.sh`
*  Merge results and place the finished result as a tarball in `/output`, ready for flashing

Provided examples out-of-the-box will be a Debian distribution with some common packages, as well as demonstrating how to install custom scripts and binaries; in this case, NTC's antenna switch script and NodeJS v6.10.2.

This build utility will automate the entire process, and intends to provide an easily-hackable jumping-off point for more complex installations.

## Requirements
First, we need to get Vagrant installed and running on our host.  (These links are assuming Linux host)

* [Install Vagrant](https://www.vagrantup.com/downloads.html)
* [Install VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads)

Install VBox Extensions as well!

```
vboxmanage extpack install --replace /path/to/ext-pack
```

## Using
To initialize the Vagrant box, first enter the `/vagrant` directory, and run:

```bash
vagrant up
```

To enter the Vagrant box:
```bash
vagrant ssh
```

This will leave you as `root` at the `/home/vagrant` directory.  From here, begin the build process by executing:

```bash
bash build-image.sh
```

Grab some tea.  This can take up to several hours!

The last stages will require manual input as `root` & `chip` user passwords will need to be entered.  These are the passwords the target device will inherit.

> Make sure, on the question asking which default system shell to use, to say "<No>" to using dash.  This can be problematic on the CHIP Pro.

---

## Customizing
### Customize Kernel
`CHIP-buildroot` is the software that will generate the kernel and module used in the target OS image.  If you want to e.g. enable extra modules (such as ENC28J60) or tweak device tree overlays, it is easiest to fork `CHIP-buildroot`, and modify it to suit your needs.  Then, to use your custom fork, update the repository being cloned inside `build-scripts/clone-buildroot.sh`.

> You may need to run `vagrant provision` to update the build environment after modifying this file.

### Customize Target Packages
This is one of the most common areas to be user-customized.  There are many Debian packages you may want to have on your CHIP Pro out-of-the-box, without having to manually run any `apt-get` commands for each device.  This build system uses `multistrap` to automate this process.  If you have packages you want included in the target OS, simply modify the contents of `resources/debian-jessie.conf`, shown below:

```
# A slightly more complex example, comprising vanilla Debian
# with a few common utilities for armhf.

[General]
arch=armhf
cleanup=true
noauth=true
unpack=true
debootstrap=Debian Net Utils Dev Custom
aptsources=Debian

[Debian]
packages=apt kmod lsof
source=http://ftp.us.debian.org/debian
keyring=debian-archive-keyring
suite=jessie
components=main contrib non-free

[Net]
#Basic packages to enable the networking
packages=netbase net-tools ethtool udev iproute iputils-ping ifupdown isc-dhcp-client wireless-tools wpasupplicant ntp ca-certificates ifenslave
source=http://ftp.us.debian.org/debian

[Utils]
#General purpose utilities
packages=locales adduser less wget dialog usbutils passwd sudo build-essential bash
source=http://ftp.us.debian.org/debian

[Dev]
#Only used for development, remove in production :)
packages=nano git grep sed findutils
source=http://ftp.us.debian.org/debian

[Custom]
# Packages germane to your business logic and use case!
packages=curl python2.7 udhcpd i2c-tools libudev-dev dbus libdbus-1-dev libglib2.0-dev libssl-dev libnl-3-dev libnl-genl-3-dev
source=http://ftp.us.debian.org/debian
```

You can create new sections in this file, remove existing sections, or even make your own file.  The only real constraint is to ensure that `suite=jessie`, or you will encounter kernel init system issues.  It's also important to ensure that `arch=armhf`.

This file (and `resources/debian-jessie-compile-env.conf`) are merely provided as examples and jumping-off points!  Feel free to tweak!

### Customizing Post-Build System
This is where a bulk of your custom business logic and user-specific configuration will take place.  Once you have the kernel, modules, and packages installed, `build-scripts/configure-chip.sh` will be executed.

Here, you can script any kind of operation you'd like to perform on the target OS before it gets bundled up as an image.

You can:

*  Copy in config files to the target image (recommended to store inside `resources/config`)
*  Install precompiled software to the target image (recommended to store inside `resources/precompiled`)
*  Install custom scripts to the traget image (recommended to store inside `resources/scripts`)

`configure-chip.sh` also includes a function called `chroot_exec` that will allow you to run any command as if it were being executed on the CHIP Pro itself!  This is accomplished by emulating the target filesystem as a chroot on an ARM processor.

It's recommended to script your post-configuration procedure by writing your own functions for each individual step.  Provided out-of-the-box are some examples, such as installing Node to the target from a tarball, or installing a script that lets you switch between the CHIP Pro's UFL and PCB antennae.

You can also jump into the target system by running:

```
bash build-scripts/mount-chroot.sh -m
bash build-scripts/mount-chroot.sh -j
```

which will dump you out at the command line of the target system as if you were inside the CHIP Pro.  Please keep in mind this is not a perfect emulation and there are many quirks and vagaries wrt to TTY and general input and ouput.

However, this kind of emulation is generally enough to perform configuration that all your images should have BEFORE being shipped and flashed, and has the added bonus of using the development host's internet connection and human interface peripherals.

Some of the `configure-chip.sh` functions are required (such as fixing sudo and binary permissions, or setting root password) and some are not (such as overwriting network interface files).  However, it should provide an easily hackable guide to fully scripting your own CHIP Pro image to meet your specific use case and business needs!
