# Copyright 2021-2023 NXP
#
# SPDX-License-Identifier: BSD-3-Clause


# NXP WiFi + Bluetooth SDK for 88w8997, 88w8987, 88w9098, etc

# https://www.nxp.com/products/wireless/wi-fi-plus-bluetooth


nxp_qca9377:
	@[ $(SOCFAMILY) != IMX -o $(DISTROVARIANT) = tiny ] && exit || \
	 $(call fbprint_b,"nxp_qca9377") && \
	 $(call repo-mngr,fetch,linux,linux) 1>/dev/null && \
	 $(call repo-mngr,fetch,nxp_qca9377,apps/connectivity) && \
	 curbrch=`cd $(KERNEL_PATH) && git branch | grep ^* | cut -d' ' -f2` && \
	 kerneloutdir=$(KERNEL_OUTPUT_PATH)/$$curbrch && \
	 if [ ! -f $$kerneloutdir/include/generated/autoconf.h ]; then \
	     bld linux -a $(DESTARCH) -p $(SOCFAMILY) -f $(CFGLISTYML); \
	 fi && \
	 export INSTALL_MOD_PATH=$$kerneloutdir/tmp && \
	 cd $(PKGDIR)/apps/connectivity/nxp_qca9377/ && \
	 if [ -d $(FBDIR)/patch/nxp_qca9377 ] && [ ! -f .patchdone ]; then \
	     git am $(FBDIR)/patch/nxp_qca9377/*.patch && touch .patchdone; \
	 fi && \
	 \
	 cp -f $(KERNEL_PATH)/include/linux/stdarg.h CORE/VOSS/inc/ && \
	 make KERNEL_SRC=$(KERNEL_PATH) KBUILD_OUTPUT=$$kerneloutdir CONFIG_CLD_HL_SDIO_CORE=y CONFIG_P2P_INTERFACE=y -j4 && \
	 kernelrelease=`cat $(KERNEL_OUTPUT_PATH)/$$curbrch/include/config/kernel.release` && \
	 sudo mkdir -p $(RFSDIR)/usr/share/nxp_wireless && \
	 install -d $$kerneloutdir/tmp/lib/modules/$$kernelrelease/kernel/drivers/net/wireless/nxp && \
	 cp -f wlan.ko $$kerneloutdir/tmp/lib/modules/$$kernelrelease/kernel/drivers/net/wireless/nxp && \
	 $(call fbprint_d,"nxp_qca9377")
