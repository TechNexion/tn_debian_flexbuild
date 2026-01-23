# Copyright 2026 TechNexion
#
# SPDX-License-Identifier: BSD-3-Clause

tn_snd:
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"tn_snd") && \
	 mkdir -p $(DESTDIR)/lib && \
	 mkdir -p $(DESTDIR)/lib/modules-load.d && \
	 echo "snd_soc_tlv320aic3x" > $(DESTDIR)/lib/modules-load.d/tn_snd.conf && \
	 echo "snd_soc_tlv320aic3x_i2c" >> $(DESTDIR)/lib/modules-load.d/tn_snd.conf && \
	 echo "snd_soc_fsl_sai" >> $(DESTDIR)/lib/modules-load.d/tn_snd.conf && \
	 $(call fbprint_d,"tn_snd")
