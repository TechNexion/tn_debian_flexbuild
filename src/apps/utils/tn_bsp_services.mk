# Copyright 2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause

# DEPENDS: glib-2.0 systemd


tn_bsp_services:
	@[ $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"tn_bsp_services") && \
	 mkdir -p $(DESTDIR)/usr/lib/systemd/system $(DESTDIR)/etc/systemd/system/multi-user.target.wants && \
	 mkdir -p $(DESTDIR)/etc/systemd/system/graphical.target.wants && \
	 mkdir -p $(DESTDIR)/usr/sbin && \
	 mkdir -p $(DESTDIR)/etc/udev/rules.d && \
	 echo -e "[tn_bsp] install resize_rfs..." && \
	 install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/resize_rfs.sh $(DESTDIR)/usr/sbin && \
	 install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/resize_rfs.service $(DESTDIR)/usr/lib/systemd/system && \
	 ln -sf /usr/lib/systemd/system/resize_rfs.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/resize_rfs.service && \
	 echo -e "[tn_bsp] install disable_auto_suspend..." && \
	 install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/disable_auto_suspend.sh $(DESTDIR)/usr/sbin && \
	 install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/setup_console_wakup_source.sh $(DESTDIR)/usr/sbin && \
	 install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/disable_auto_suspend.service $(DESTDIR)/usr/lib/systemd/system && \
	 ln -sf /usr/lib/systemd/system/disable_auto_suspend.service $(DESTDIR)/etc/systemd/system/graphical.target.wants/disable_auto_suspend.service && \
	 echo -e "[tn_bsp] install media_setup..." && \
	 install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/media_setup.sh $(DESTDIR)/usr/sbin && \
	 install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/media_setup.service $(DESTDIR)/usr/lib/systemd/system && \
	 ln -sf /usr/lib/systemd/system/media_setup.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/media_setup.service && \
	 echo -e "[tn_bsp] install udev..." && \
	 install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/udev-retry.service $(DESTDIR)/usr/lib/systemd/system && \
	 ln -sf /usr/lib/systemd/system/udev-retry.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/udev-retry.service && \
	 install -m 0660 $(FBDIR)/src/apps/utils/tn_bsp_services/99-dma-heap.rules $(DESTDIR)/etc/udev/rules.d && \
	 if [ "$${MACHINE:0:5}" != "imx91" ] && [ "$${MACHINE:0:5}" != "imx93" ]; then \
		echo -e "[tn_bsp] install wayland_init..." && \
		install -m 0755 $(FBDIR)/src/apps/utils/tn_bsp_services/wayland_init.sh $(DESTDIR)/usr/sbin && \
		install -m 0644 $(FBDIR)/src/apps/utils/tn_bsp_services/wayland_init.service $(DESTDIR)/usr/lib/systemd/system && \
		ln -sf /usr/lib/systemd/system/wayland_init.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/wayland_init.service; \
	 fi && \
	 $(call fbprint_d,"tn_bsp_services")
