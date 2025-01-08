# Copyright 2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause

# DEPENDS: glib-2.0 systemd


tn_bsp_services:
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"tn_bsp_services") && \
	 mkdir -p $(DESTDIR)/usr/lib/systemd/system $(DESTDIR)/etc/systemd/system/multi-user.target.wants && \
	 mkdir -p $(DESTDIR)/usr/sbin && \
	 echo -e "[tn_bsp] install resize_rfs..." && \
	 install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/resize_rfs.sh $(DESTDIR)/usr/sbin && \
	 install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/resize_rfs.service $(DESTDIR)/usr/lib/systemd/system && \
	 ln -sf /usr/lib/systemd/system/resize_rfs.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/resize_rfs.service && \
	 $(call fbprint_d,"tn_bsp_services")
