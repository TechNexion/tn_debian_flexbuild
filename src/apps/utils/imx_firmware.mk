# Copyright 2017-2025 NXP
#
# SPDX-License-Identifier: BSD-3-Clause



imx_firmware:
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call download_repo,imx_firmware,apps/utils) && \
	 $(call patch_apply,imx_firmware,apps/utils) && \
	 cd $(UTILSDIR)/imx_firmware && \
	 mkdir -p $(DESTDIR)/lib/firmware/{nxp,imx,brcm} $(LOG_MUTE) && \
	 echo Installing NXP WIFI/BT firmware && \
	 cp -f $(UTILSDIR)/imx_firmware/FwImage_*/* $(DESTDIR)/lib/firmware/nxp 2>/dev/null || true && \
	 cp -f $(UTILSDIR)/imx_firmware/mfguart/*.bin $(DESTDIR)/lib/firmware/nxp && \
	 cp -f $(UTILSDIR)/imx_firmware/wifi_mod_para.conf $(DESTDIR)/lib/firmware/nxp && \
	 \
	 echo Installing bt/wifi firmware qca9377 && \
	 cd $(UTILSDIR) && \
	 if [ ! -d $(UTILSDIR)/QCA9377_FIRMWARE ]; then \
	     cd $(UTILSDIR) && \
	     git clone https://oauth2:SbtQ_mC4fvJRA88_9jB7@gitlab.com/technexion-imx/qca_firmware.git QCA9377_FIRMWARE ; \
	 fi && \
	 cp -Prf $(UTILSDIR)/QCA9377_FIRMWARE/* $(DESTDIR)/lib/firmware/ && \
	 \
	 echo Installing bt/wifi firmware qca9377 of pcie card && \
	 if [ ! -d $(UTILSDIR)/ATH10K_FIRMWARE ]; then \
	     cd $(UTILSDIR) && \
	     git clone  https://git.codelinaro.org/clo/ath-firmware/ath10k-firmware.git ATH10K_FIRMWARE ; \
	 fi && \
	 mkdir -p $(DESTDIR)/lib/firmware/ath10k && \
	 mkdir -p $(DESTDIR)/lib/firmware/ath10k/QCA9377 && \
	 mkdir -p $(DESTDIR)/lib/firmware/ath10k/QCA9377/hw1.0 && \
	 cp -Prf $(UTILSDIR)/ATH10K_FIRMWARE/QCA9377/hw1.0/*.bin $(DESTDIR)/lib/firmware/ath10k/QCA9377/hw1.0/ && \
	 cp -Prf $(UTILSDIR)/ATH10K_FIRMWARE/LICENSE.qca_firmware $(DESTDIR)/lib/firmware/ath10k/QCA9377/hw1.0/ && \
	 cp -Prf $(UTILSDIR)/ATH10K_FIRMWARE/QCA9377/hw1.0/CNSS.TF.1.0/firmware-5.bin_CNSS.TF.1.0-00267-QCATFSWPZ-1 $(DESTDIR)/lib/firmware/ath10k/QCA9377/hw1.0/firmware-5.bin && \
	 $(call fbprint_d,"imx_firmware")
