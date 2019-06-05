#
#  Copyright (C)      2019 Gaël PORTAY
#                2017-2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

initramfs.cpio: rootfs/etc/init.d/rcS rootfs/etc/inittab

rootfs/etc/init.d:
	mkdir -p $@

rootfs/etc/init.d/rcS: $(KMINCDIR)/rcS | rootfs/etc/init.d
	install -D -m 755 $< $@

rootfs/etc/inittab: $(KMINCDIR)/inittab | rootfs/etc
	install -D -m 644 $< $@

# ex: filetype=make
