# Copyright 2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause


# The Linux Firmware Loader Daemon monitors the kernel for firmware requests and uploads the firmware blobs it has via the sysfs interface
# https://github.com/TechNexion/meta-tn-wifi

tn_bluez:
	@[ $(DESTARCH) != arm64 -o $(SOCFAMILY) != IMX ] && exit || \
	 $(call fbprint_b,"tn_bluez") && \
	 $(call repo-mngr,fetch,tn_bluez,apps/connectivity) && \
	 mkdir -p $(DESTDIR)/usr/lib/systemd/system $(DESTDIR)/etc/systemd/system/multi-user.target.wants $(DESTDIR)/opt/btattach $(DESTDIR)/usr/sbin && \
	 install -m 0755 $(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/btattach.sh $(DESTDIR)/opt/btattach/ && \
	 install -m 0644 $(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/serial-btattach@.service $(DESTDIR)/usr/lib/systemd/system/ && \
	 install -m 0644 $(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/serial-btattach@.timer $(DESTDIR)/usr/lib/systemd/system/ && \
	 install -m 0644 $(FBDIR)/src/apps/connectivity/tn_bluez/setup-serial-btattach.service $(DESTDIR)/usr/lib/systemd/system/  && \
	 install -m 0755 $(FBDIR)/src/apps/connectivity/tn_bluez/setup_serial_btattach.sh $(DESTDIR)/usr/sbin/  && \
	 ln -sf /usr/lib/systemd/system/setup-serial-btattach.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/setup-serial-btattach.service && \
	 cd $(PKGDIR)/apps/connectivity/tn_bluez && \
	 if [ ! -d $(PKGDIR)/apps/connectivity/tn_bluez/bluez ];then \
		git clone https://github.com/bluez/bluez.git; \
	 fi && \
	 cd $(PKGDIR)/apps/connectivity/tn_bluez/bluez && \
	 git reset --hard 5.66 && \
	 git am  \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0001-bluetooth-Add-bluetooth-support-for-QCA6174-chip.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0002-hciattach-set-flag-to-enable-HCI-reset-on-init.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0003-hciattach-instead-of-strlcpy-with-strncpy-to-avoid-r.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0004-Add-support-for-Tufello-1.1-SOC.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0005-bluetooth-Add-support-for-multi-baud-rate.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0001-hciattach_rome-do-not-override-module-MAC-address.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0002-hciattach_rome-set-IBS-to-disable-and-PCM-to-slave-b.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0003-hciattach_rome-load-3.2-version-of-firmware-by-defau.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0004-hciattach_rome-fix-baud-rate-synchronization-issue.patch \
		$(PKGDIR)/apps/connectivity/tn_bluez/recipes-connectivity/bluez5/files/0001-hciattach_rome-use-the-same-firmware-path.patch && \
	 \
	 export CC="$(CROSS_COMPILE)gcc --sysroot=$(RFSDIR)" && \
	 export CXX="$(CROSS_COMPILE)g++ --sysroot=$(RFSDIR)" && \
	 export LIBS="-lsystemd -ltinfo" && \
	 export LDFLAGS="-L$(RFSDIR)/usr/lib -L$(DESTDIR)/usr/lib -L$(RFSDIR)/usr/lib/aarch64-linux-gnu -lsystemd -ltinfo" && \
	 export PKG_CONFIG_PATH=$(RFSDIR)/usr/lib/aarch64-linux-gnu/pkgconfig:$(RFSDIR)/usr/share/pkgconfig  && \
	 export CFLAGS="-Wno-write-strings -I$(RFSDIR)/usr/include/aarch64-linux-gnu \
		-I$(PKGDIR)/apps/connectivity/tn_bluez/bluez/android/" && \
	 ./bootstrap && \
	 ./configure --prefix=/usr --host=aarch64-linux-gnu --disable-obex --enable-tools --enable-deprecated && \
	 make -C $(PKGDIR)/apps/connectivity/tn_bluez/bluez && \
	 mkdir -p $(DESTDIR)/usr/bin && \
	 install -m 0755 $(PKGDIR)/apps/connectivity/tn_bluez/bluez/tools/hciattach $(DESTDIR)/usr/bin/ && \
	 $(call fbprint_d,"tn_bluez")
