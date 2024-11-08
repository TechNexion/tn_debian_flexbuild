# Copyright 2017-2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause



imx_firmware:
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call repo-mngr,fetch,imx_firmware,bsp) && \
	 cd $(BSPDIR)/imx_firmware && \
	 if [ -d $(FBDIR)/patch/imx_firmware ] && [ ! -f .patchdone ]; then \
	     git am $(FBDIR)/patch/imx_firmware/*.patch && touch .patchdone; \
	 fi && \
	 mkdir -p $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/{nxp,imx,brcm} && \
	 echo Installing NXP WIFI/BT firmware && \
	 cp -f $(BSPDIR)/imx_firmware/nxp/FwImage_*/* $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/nxp 2>/dev/null || true && \
	 cp -f $(BSPDIR)/imx_firmware/nxp/mfguart/*.bin $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/nxp && \
	 cp -f $(BSPDIR)/imx_firmware/nxp/wifi_mod_para.conf $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/nxp && \
	 echo Installing Murata WIFI/BT firmware && \
	 cp -f $(BSPDIR)/imx_firmware/cyw-wifi-bt/*/{*.bin,*.clm_blob,*.txt} $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/brcm/ && \
	 cp -f $(BSPDIR)/imx_firmware/cyw-wifi-bt/*/*.hcd $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ && \
	 \
	 echo Installing firmware-imx for ddr,hdmi,dp,vpu,easrc,epdc,xcvr,xuvi && \
	 if [ ! -d $(BSPDIR)/firmware-imx ]; then \
	     cd $(BSPDIR) && wget -q $(repo_firmware_imx_bin_url) -O firmware_imx.bin && \
	     chmod +x firmware_imx.bin && \
	     ./firmware_imx.bin --auto-accept && mv firmware-imx* firmware-imx && rm -f firmware_imx.bin; \
	 fi && \
	 cp -Prf $(BSPDIR)/firmware-imx/firmware/* $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/imx/ && \
	 \
	 echo Installing bt/wifi firmware qca9377 && \
	 cd $(BSPDIR) && \
	 if [ ! -d $(BSPDIR)/QCA9377_FIRMWARE ]; then \
	     cd $(BSPDIR) && \
	     git clone https://oauth2:SbtQ_mC4fvJRA88_9jB7@gitlab.com/technexion-imx/qca_firmware.git QCA9377_FIRMWARE ; \
	 fi && \
	 cp -Prf $(BSPDIR)/QCA9377_FIRMWARE/* $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ && \
	 \
	 echo Installing bt/wifi firmware qca9377 of pcie card && \
	 if [ ! -d $(BSPDIR)/ATH10K_FIRMWARE ]; then \
	     cd $(BSPDIR) && \
	     git clone  https://git.codelinaro.org/clo/ath-firmware/ath10k-firmware.git ATH10K_FIRMWARE ; \
	 fi && \
	 mkdir -p $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k && \
	 mkdir -p $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k/QCA9377 && \
	 mkdir -p $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k/QCA9377/hw1.0 && \
	 cp -Prf $(BSPDIR)/ATH10K_FIRMWARE/QCA9377/hw1.0/*.bin $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k/QCA9377/hw1.0/ && \
	 cp -Prf $(BSPDIR)/ATH10K_FIRMWARE/LICENSE.qca_firmware $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k/QCA9377/hw1.0/ && \
	 cp -Prf $(BSPDIR)/ATH10K_FIRMWARE/QCA9377/hw1.0/CNSS.TF.1.0/firmware-5.bin_CNSS.TF.1.0-00267-QCATFSWPZ-1 $(FBOUTDIR)/bsp/imx_firmware/lib/firmware/ath10k/QCA9377/hw1.0/firmware-5.bin && \
	 $(call fbprint_d,"imx_firmware")
