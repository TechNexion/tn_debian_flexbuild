# Copyright 2026 TechNexion
#
# SPDX-License-Identifier: BSD-3-Clause

tn_media:
	@[ $${MACHINE:0:7} != imx8mm- ] && exit || \
	 $(call fbprint_b,"tn_media") && \
	 mkdir -p $(DESTDIR)/lib && \
	 mkdir -p $(DESTDIR)/lib/modules-load.d && \
	 echo "imx_mipi_csis" > $(DESTDIR)/lib/modules-load.d/tn_media.conf && \
	 echo "imx7_media_csi" >> $(DESTDIR)/lib/modules-load.d/tn_media.conf && \
	 $(call fbprint_d,"tn_media")
