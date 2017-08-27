# Flashing the CHIP Pro
> In my personal experience, these tools only work well on an actual Linux host.
> All commands below are assumed to be run from the `flashing/` directory.

Once we have a valid `chip-base-image.tar.gz` inside `/vagrant/output` containing the target OS for the CHIP Pro, we need to do two things:

*  Bundle this tarball into a NAND image
*  Flash the NAND image to the CHIP Pro

## Requirements
For bundling and flashing, we will require the `CHIP-tools` repository.  This can be cloned locally by running

```bash
bash clone-chip-tools.sh
```

## Bundle
First, we must create a flashable NAND image from the tar ball in `vagrant/output`.  To do this, run:

```bash
bash bundle.sh
```

If this completes successfully, there should now be a `flashing/nand-image` directory.

> This can take a while!

## Flash
Hold the FEL button on the CHIP Pro, and connect it to the host via the USB connection (USB0 UART if on DevKit).  Continue holding the FEL button for about 5 seconds after connection, and then you can release it (this ensures the CHIP completely boots into and stays in FEL mode).

When you are ready to begin the flash, hold down the FEL button again, and execute:

```bash
bash flash.sh
```

You must continue holding the FEL button down until the flashing agent reports that it is sending and/or writing (sparse) UBI information.

> The CHIP pro will reboot several times during flashing, and if the FEL button is not held down, it will not reboot into programming mode and the attempt will fail.
