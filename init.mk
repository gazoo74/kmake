#
#  Copyright (C)      2019 Gaël PORTAY
#                2017-2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

$(obj)/initramfs.cpio: $(obj)/rootfs/etc/init.d/rcS $(obj)/rootfs/etc/inittab

$(obj)/rootfs/etc/init.d:
	mkdir -p $@

$(obj)/rootfs/etc/init.d/rcS: $(KMINCDIR)/rcS | $(obj)/rootfs/etc/init.d
	install -D -m 755 $< $@

$(obj)/rootfs/etc/inittab: $(KMINCDIR)/inittab | $(obj)/rootfs/etc
	install -D -m 644 $< $@

# ex: filetype=make
