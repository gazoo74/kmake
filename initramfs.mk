#
#  Copyright (C) 2017-2018 Savoir-Faire Linux Inc.
#
#  Authors:
#      Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 2.1 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

.PHONY: all
all:

.PHONY: clean
clean: initramfs_clean

.PHONY: mrproper
mrproper: initramfs_mrproper

include busybox.mk

initramfs.cpio: ramfs

$(obj)/ramfs $(obj)/ramfs/dev $(obj)/ramfs/proc $(obj)/ramfs/sys $(obj)/ramfs/etc $(obj)/ramfs/root:
	mkdir -p $@

$(obj)/ramfs/init $(obj)/ramfs/linuxrc: $(KMINCDIR)/init
	install -D -m 755 $< $@

$(obj)/ramfs/dev/initrd: | $(obj)/ramfs/dev
	fakeroot -i ramfs.env -s ramfs.env -- mknod -m 400 $@ b 1 250

$(obj)/ramfs/dev/console: | $(obj)/ramfs/dev
	fakeroot -i ramfs.env -s ramfs.env -- mknod -m 622 $@ c 5 1

$(obj)/ramfs/etc/passwd: | $(obj)/ramfs/etc
	echo "root::0:0:root:/root:/bin/sh" >$@

$(obj)/ramfs/etc/group: | $(obj)/ramfs/etc
	echo "root:x:0:root" >$@

$(obj)/initramfs.cpio.gz:

$(obj)/initramfs.cpio: | $(obj)/ramfs/proc $(obj)/ramfs/sys
$(obj)/initramfs.cpio: $(obj)/ramfs/bin/busybox $(obj)/ramfs/dev/console $(obj)/ramfs/init

include init.mk

$(obj)/initramfs.cpio: $(obj)/ramfs/etc/passwd $(obj)/ramfs/etc/group | $(obj)/ramfs/root

%.cpio:
	cd $< && find . | \
	fakeroot -i $(CURDIR)/ramfs.env -s $(CURDIR)/ramfs.env -- \
	cpio -H newc -o -R root:root >$(CURDIR)/$@

%.gz: %
	gzip -9 $*

.PHONY: initramfs_clean
initramfs_clean:
	rm -Rf $(obj)/ramfs/ $(obj)/ramfs.env
	rm -f initramfs.cpio

.PHONY: initramfs_mrproper
initramfs_mrproper:

# ex: filetype=makefile
