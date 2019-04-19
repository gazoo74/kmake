#
#  Copyright (C) 2017-2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

.PHONY: clean
clean: initramfs_clean

.PHONY: mrproper
mrproper: initramfs_mrproper

include busybox.mk

initramfs.cpio: rootfs 

rootfs rootfs/dev rootfs/proc rootfs/sys rootfs/etc rootfs/root rootfs/tmp:
	mkdir -p $@

rootfs/init rootfs/linuxrc: $(KMINCDIR)/init
	install -D -m 755 $< $@

rootfs/dev/initrd: | rootfs/dev
	fakeroot -i rootfs.env -s rootfs.env -- mknod -m 400 $@ b 1 250

rootfs/dev/console: | rootfs/dev
	fakeroot -i rootfs.env -s rootfs.env -- mknod -m 622 $@ c 5 1

rootfs/etc/passwd: | rootfs/etc
	echo "root::0:0:root:/root:/bin/sh" >$@

rootfs/etc/group: | rootfs/etc
	echo "root:x:0:root" >$@

initramfs.cpio.gz:

initramfs.cpio: | rootfs/proc rootfs/sys rootfs/tmp
initramfs.cpio: rootfs/bin/busybox rootfs/dev/console rootfs/init

include init.mk

initramfs.cpio: rootfs/etc/passwd rootfs/etc/group | rootfs/root

%.cpio:
	cd $< && find . | \
	fakeroot -i $(CURDIR)/rootfs.env -s $(CURDIR)/rootfs.env -- \
	cpio -H newc -o -R root:root >$(CURDIR)/$@

%.gz: %
	gzip -9 $*

.PHONY: initramfs_clean
initramfs_clean:
	rm -Rf rootfs/ rootfs.env
	rm -f initramfs.cpio

.PHONY: initramfs_mrproper
initramfs_mrproper:

# ex: filetype=make
