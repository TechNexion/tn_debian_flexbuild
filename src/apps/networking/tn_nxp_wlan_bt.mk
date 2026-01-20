# Copyright 2025 TechNexion
#
# SPDX-License-Identifier: BSD-3-Clause

tn_nxp_wlan_bt:
	@[ $(SOCFAMILY) != IMX -o $(DISTROVARIANT) = base -o $(DISTROVARIANT) = tiny ] && exit || \
	 $(call fbprint_b,"tn_nxp_wlan_bt") && \
	 mkdir -p $(DESTDIR)/lib && \
	 mkdir -p $(DESTDIR)/lib/modprobe.d && \
	 mkdir -p $(DESTDIR)/lib/modules-load.d && \
	 echo "options moal mod_para=nxp/wifi_mod_para.conf" > $(DESTDIR)/lib/modprobe.d/moal.conf && \
	 echo "moal" > $(DESTDIR)/lib/modules-load.d/moal.conf && \
	 echo "btnxpuart" > $(DESTDIR)/lib/modules-load.d/btnxpuart.conf && \
	 echo "softdep btnxpuart pre: moal" > $(DESTDIR)/lib/modprobe.d/bt_sequence.conf && \
	 $(call fbprint_d,"tn_nxp_wlan_bt")
