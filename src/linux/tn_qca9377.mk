# Copyright 2025 TechNexion
#
# SPDX-License-Identifier: ISC

# The QCA9377 driver is a Linux kernel module for the Qualcomm Atheros QCA9377 Wi-Fi and Bluetooth chipset.

tn_qca9377:
	@[ $(SOCFAMILY) != IMX  ] && exit || \
	 $(call download_repo,linux,linux) 1>/dev/null && \
	 $(call download_repo,tn_qca9377,linux) && \
	 kerneloutdir=$(KERNEL_OUTPUT_PATH)/$(KERNEL_BRANCH) && \
	 export INSTALL_MOD_PATH=$$kerneloutdir/tmp && \
	 $(call fbprint_b,"tn_qca9377") && \
	 cd $(PKGDIR)/linux/tn_qca9377 && \
	 $(call patch_apply,tn_qca9377,linux) && \
	 \
	 cp -f $(KERNEL_PATH)/include/linux/stdarg.h CORE/VOSS/inc/ && \
	 $(MAKE) KERNEL_SRC=$(KERNEL_PATH) KBUILD_OUTPUT=$$kerneloutdir CONFIG_CLD_HL_SDIO_CORE=y -j$(JOBS) $(LOG_MUTE) && \
	 kernelrelease=`cat $(KERNEL_OUTPUT_PATH)/$(KERNEL_BRANCH)/include/config/kernel.release` && \
	 mkdir -p $(DESTDIR)/usr/share/nxp_wireless && \
	 install -d $$kerneloutdir/tmp/lib/modules/$$kernelrelease/kernel/drivers/net/wireless/nxp && \
	 cp -f wlan.ko $$kerneloutdir/tmp/lib/modules/$$kernelrelease/updates/ && \
	 cp -f README.adoc $(DESTDIR)/usr/share/nxp_wireless/ && \
	 $(call fbprint_d,"tn_qca9377")
