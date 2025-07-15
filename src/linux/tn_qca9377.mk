# Copyright 2025 TechNexion
#
# SPDX-License-Identifier: ISC

# The QCA9377 driver is a Linux kernel module for the Qualcomm Atheros QCA9377 Wi-Fi and Bluetooth chipset.

tn_qca9377:
	@[ $(SOCFAMILY) != IMX -o $(DISTROVARIANT) = base -o $(DISTROVARIANT) = tiny ] && exit || \
	 $(call repo-mngr,fetch,linux,linux) 1>/dev/null && \
	 $(call repo-mngr,fetch,tn_qca9377,linux) && \
	 curbrch=`cd $(KERNEL_PATH) && git branch | grep ^* | cut -d' ' -f2` && \
	 kerneloutdir=$(KERNEL_OUTPUT_PATH)/$$curbrch && \
	 export INSTALL_MOD_PATH=$$kerneloutdir/tmp && \
	 $(call fbprint_b,"tn_qca9377") && \
	 cd $(PKGDIR)/linux/tn_qca9377/ && \
	 if [ -d $(FBDIR)/patch/tn_qca9377 ] && [ ! -f .patchdone ]; then \
	     git am $(FBDIR)/patch/tn_qca9377/*.patch $(LOG_MUTE) && touch .patchdone; \
	 fi && \
	 \
	 cp -f $(KERNEL_PATH)/include/linux/stdarg.h CORE/VOSS/inc/ && \
	 $(MAKE) KERNEL_SRC=$(KERNEL_PATH) KBUILD_OUTPUT=$$kerneloutdir CONFIG_CLD_HL_SDIO_CORE=y -j$(JOBS) $(LOG_MUTE) && \
	 kernelrelease=`cat $(KERNEL_OUTPUT_PATH)/$$curbrch/include/config/kernel.release` && \
	 mkdir -p $(RFSDIR)/usr/share/nxp_wireless && \
	 install -d $$kerneloutdir/tmp/lib/modules/$$kernelrelease/kernel/drivers/net/wireless/nxp && \
	 cp -f wlan.ko $$kerneloutdir/tmp/lib/modules/$$kernelrelease/updates/ && \
	 $(call fbprint_d,"tn_qca9377")
