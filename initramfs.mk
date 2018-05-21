#
#  Copyright (C)      2019 Gaël PORTAY
#                2017-2018 Savoir-Faire Linux Inc.
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

$(obj)/initramfs.cpio: $(obj)/rootfs

$(obj)/rootfs $(obj)/rootfs/dev $(obj)/rootfs/proc $(obj)/rootfs/sys $(obj)/rootfs/etc $(obj)/rootfs/root $(obj)/rootfs/tmp:
	mkdir -p $@

$(obj)/rootfs/init $(obj)/rootfs/linuxrc: $(KMINCDIR)/init
	install -D -m 755 $< $@

$(obj)/rootfs/dev/initrd: | $(obj)/rootfs/dev
	fakeroot -i rootfs.env -s rootfs.env -- mknod -m 400 $@ b 1 250

$(obj)/rootfs/dev/console: | $(obj)/rootfs/dev
	fakeroot -i rootfs.env -s rootfs.env -- mknod -m 622 $@ c 5 1

$(obj)/rootfs/etc/passwd: | $(obj)/rootfs/etc
	echo "root::0:0:root:/root:/bin/sh" >$@

$(obj)/rootfs/etc/group: | $(obj)/rootfs/etc
	echo "root:x:0:root" >$@

$(obj)/initramfs.cpio.gz:

$(obj)/initramfs.cpio: | $(obj)/rootfs/proc $(obj)/rootfs/sys $(obj)/rootfs/tmp
$(obj)/initramfs.cpio: $(obj)/rootfs/bin/busybox $(obj)/rootfs/dev/console $(obj)/rootfs/init
#$(obj)/initramfs.cpio: $(obj)/rootfs/lib/modules/$(shell $(MAKE) kernelversion)/modules.order

include init.mk

$(obj)/initramfs.cpio: $(obj)/rootfs/etc/passwd $(obj)/rootfs/etc/group | $(obj)/rootfs/root

%.cpio:
	cd $< && find . | \
	fakeroot -i $(CURDIR)/rootfs.env -s $(CURDIR)/rootfs.env -- \
	cpio -H newc -o -R root:root >$(CURDIR)/$@

%.gz: %
	gzip -9 $*

.PHONY: initramfs
initramfs: $(obj)/initramfs.cpio

.PHONY: initramfs_clean
initramfs_clean:
	rm -Rf $(obj)/rootfs/ $(obj)/rootfs.env
	rm -f $(obj)/initramfs.cpio

.PHONY: initramfs_mrproper
initramfs_mrproper:

# ex: filetype=make
