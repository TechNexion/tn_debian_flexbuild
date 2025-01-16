## FlexBuild Overview
---------------------
FlexBuild is a component-oriented lightweight build system and integration platform with
capabilities of flexible, ease-to-use, scalable system build and distro deployment.

Users can use flexbuild to easily build Debian-based RootFS, linux kernel, BSP
components and miscellaneous userspace applications (e.g. graphics, multimedia,
networking, connectivity, security, AI/ML, robotics, etc) against Debian-based library
dependencies to streamline the system build with efficient CI/CD.

With flex-installer, users also can easily install various distro to target storage
device (SD/eMMC card or USB/SATA disk) on target board or on host machine.


## Build Environment
--------------------
- Cross-build in Debian Docker container hosted on x86 Ubuntu or any other distro for arm64 target
- Cross-build on x86 host machine running Debian 12 for arm64 target
- Native-build on ARM board running Debian for arm64 target

## Host system requirement
- Docker hosted on Ubuntu LTS host (e.g. 22.04, 20.04) or other any distro
  Refer to [docker-setup](docs/FAQ-docker-setup.md)
  User can run 'bld docker' to create a Debian docker and build it in docker.
- Debian 12 host
  Refer to [host_requirement](docs/host_requirement.md)


## Supported distro for target arm64
------------------------------------------
- Debian-based userland    (base, desktop, server)
- Yocto-based userland     (tiny, devel)
- Buildroot-based userland (tiny, devel)


## Supported platforms
----------------------
- __TechNexion iMX platform__:  
imx8mp-edm-g, imx8mm-edm-g

- __iMX platform__:  
imx6qpsabresd, imx6qsabresd, imx6sllevk, imx7ulpevk, imx8mmevk, imx8mnevk, imx8mpevk,  
imx8mqevk, imx8qmmek, imx8qxpmek, imx8ulpevk, imx93evk, imx91frdm, imx93frdm, etc


## Flexbuild Usage
------------------
#### Setup docker env of debian 12
```
$ cd flexbuild
$ . setup.env  (in host environment)
$ bld docker   (create or attach to docker)
$ . setup.env  (in docker environment)
$ bld host-dep (install host dependent packages)

Usage: bld -m <machine>
   or  bld <target> [ <option> ]
```

#### Most used example with automated build:
```
 bld -m imx8mp-edm-g                # automatically build BSP + kernel + NXP-specific components + Debian RootFS for TechNexion edm-g-imx8mp
 bld -m imx8mm-edm-g                # same as above, for TechNexion edm-g-imx8mp
 bld auto -p IMX                    # same as above, for all arm64 iMX platforms
```

#### Most used example with step-by-step build( Same result as using `$ bld auto -p IMX` ):
(To build one platform only, you can swap `-p IMX` to `-m <machine>`)
```
# create general rootfs with NXP-specific components all IMX platforms
 bld rfs -p IMX               # create rootfs with debian desktop, for other rootfs: [-r debian:server | -r debian:base | -r poky:tiny ]
 bld apps -p IMX              # create NXP-specific components(apps) for all IMX platforms, depends on rootfs created above
 bld merge-apps -p IMX        # merge NXP-specific components(apps) to rootfs.
 bld packrfs -p IMX           # pack rootfs to 'build_lsdk2412>/images/'

# create all boot image for all IMX platforms
 bld boot -p IMX              # create boot partitions for all IMX pltforms to 'build_lsdk2412>/images/'

# create all firmware image for all IMX platforms
 bld fwall -p IMX             # create all fw for all IMX platforms to 'build_lsdk2412>/images/'
```

#### Most used example with separate command:
```
 bld bsp -m imx8mpevk            # generate BSP composite firmware (including atf/u-boot/kernel/dtb/peripheral-firmware/initramfs) for single machine
 bld bspall [ -p IMX|LS ]        # generate BSP composite firmware for all i.MX or LS machines
 bld rfs [ -r debian:desktop ]   # generate Debian-based Desktop rootfs  (with more graphics/multimedia packages for Desktop)
 bld rfs -r debian:server        # generate Debian-based Server rootfs   (with more server related packages, no GUI Desktop)
 bld rfs -r debian:base          # generate Debian-based base rootfs     (small footprint with base packages)
 bld rfs -r poky:tiny            # generate poky-based arm64 tiny rootfs
 bld rfs -r buildroot:tiny       # generate Buildroot-based arm64 tiny rootfs
 bld itb -r poky:tiny            # generate poky_tiny_IMX_arm64.itb including kernel, dtb and rootfs_poky_tiny_arm64.cpio.gz
 bld linux [ -p IMX|LS]          # compile linux kernel for all arm64 IMX or LS machines
 bld atf -m lx2160rdb -b sd      # compile atf image for SD boot on lx2160ardb
 bld boot [ -p IMX|LS ]          # generate boot partition tarball (including kernel,dtb,modules,distro bootscript) for iMX/LS machines
 bld apps                        # compile NXP-specific components against the runtime dependencies of Debian Desktop rootfs for i.MX machines
 bld apps -r debian:server -p LS # compile NXP-specific components against the runtime dependencies of Debian Server rootfs for LS machines
 bld ml [ -r <type> ]            # compile NXP-specific eIQ AI/ML components against the library dependencies of Debian rootfs
 bld merge-apps [ -r <type> ]    # merge NXP-specific components into target Debian rootfs (Desktop by default,add '-r debian:server' for Server)
 bld packrfs [ -r <type> ]       # pack and compress target rootfs as rootfs_xx.tar.zst (or add '-r debian:server' for Server)
 bld packapps [ -r <type> ]      # pack and compress target app components as apps_xx.tar.zst (add '-p LS' for Layerscape platforms)
 bld repo-fetch [ <component> ]  # fetch git repository of all or specified component from remote repos if not exist locally
 bld docker                      # create or attach docker container to build in docker
 bld clean                       # clean all obsolete firmware/linux/apps binary images except distro rootfs
 bld clean-apps [ -r <type> ]    # clean the obsolete NXP-specific apps components binary images
 bld clean-rfs [ -r <type> ]     # clean target debian-based server arm64 rootfs
 bld clean-bsp                   # clean obsolete BSP (u-boot/atf/firmware) images
 bld clean-linux                 # clean obsolete linux image
 bld list                        # list enabled machines and supported various components
 bld host-dep                    # automatically install the depended deb packages on host
```

## Deploy (flex-installer) usage example:
( `flex-installer` is in `PATH` when running `$ . setenv`. If you don't, need to swap `flex-installer` to `./flex-installer` )
### Go to build image folder
```
$ cd build_lsdk2412/images/
```
### Flash directly to block device(/dev/sd<X>):
#### Format block device
```
$ flex-installer -i pf -d /dev/sd<x>
```
#### == For EDM-G-IMX8MP ==
```
$ flex-installer -m imx8mp-edm-g -d /dev/sd<X> -b boot_IMX_arm64_imx8mp-edm-g_lts_6.6.52 -f firmware_imx8mp-edm-g_sdboot.img -r rootfs_lsdk2412_debian_desktop_arm64.tar.zst
```
#### == For EDM-G-IMX8MM ==
```
$ flex-installer -m imx8mm-edm-g -d /dev/sd<X> -b boot_IMX_arm64_imx8mm-edm-g_lts_6.6.52 -f firmware_imx8mm-edm-g_sdboot.img -r rootfs_l2412_debian_desktop_arm64.tar.zst
```
### Create sdcard image (8GB size image named `sdcard.wic`):
#### == For EDM-G-IMX8MP ==
```
$ flex-installer -m imx8mp-edm-g -i mkwic -b boot_IMX_arm64_imx8mp-edm-g_lts_6.6.52 -f firmware_imx8mp-edm-g_sdboot.img -r rootfs_lsdk2412_debian_desktop_arm64.tar.zst
```
#### == For EDM-G-IMX8MM ==
```
$ flex-installer -m imx8mm-edm-g -i mkwic -b boot_IMX_arm64_imx8mm-edm-g_lts_6.6.52 -f firmware_imx8mm-edm-g_sdboot.img -r rootfs_lsdk2412_debian_desktop_arm64.tar.zst
```

## More info
------------
Please refer to https://nxp.com/nxpdebian for more information about NXP Debian Linux SDK Distribution for i.MX and Layerscape.
[i.MX Debian Linux SDK User's Guide](https://nxp.com/docs/en/user-guide/UG10155.pdf).
[Layerscape Debian Linux SDK User's Guide](https://nxp.com/docs/en/user-guide/UG10143.pdf).

[flexbuild_usage](docs/flexbuild_usage.md), [build_and_deploy_distro](docs/build_and_deploy_distro.md), [nxp_linux_](docs/nxp_linux_.md) for detailed information.
