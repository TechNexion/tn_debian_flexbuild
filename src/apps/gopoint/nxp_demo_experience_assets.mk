# Copyright 2025 NXP
#
# SPDX-License-Identifier: BSD-3-Clause

# section: iMX gopoint
# description: NXP nxp_demo_experience_assets
# 
# depends on: alsa-lib nxp-afe imx-voiceui
#

nxp_demo_experience_assets:
ifeq ($(CONFIG_NXP_DEMO_EXPERIENCE_ASSETS),"y")
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"nxp_demo_experience_assets") && \
	 $(call download_repo,nxp_demo_experience_assets,apps/gopoint) && \
	 $(call patch_apply,nxp_demo_experience_assets,apps/gopoint) && \
	 cd $(GPDIR)/nxp_demo_experience_assets && \
	 if [ ! -f .codedone ]; then \
		 git clone https://oauth2:SbtQ_mC4fvJRA88_9jB7@gitlab.com/technexion-imx/nxp_vit_model.git; $(LOG_MUTE)\
		 cp -Prf nxp_vit_model/* ./ && touch .codedone && rm -rf nxp_vit_model/; \
	 fi && \
	 \
	 $(call fbprint_d,"nxp_demo_experience_assets")
endif
