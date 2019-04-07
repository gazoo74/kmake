#
#  Copyright (C) 2017-2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

initramfs.cpio: ramfs/etc/init.d/rcS ramfs/etc/inittab

ramfs/etc/init.d:
	mkdir -p $@

ramfs/etc/init.d/rcS: $(KMINCDIR)/rcS | ramfs/etc/init.d
	install -D -m 755 $< $@

ramfs/etc/inittab: $(KMINCDIR)/inittab | ramfs/etc
	install -D -m 644 $< $@

# ex: filetype=make
