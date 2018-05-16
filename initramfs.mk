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

ramfs ramfs/dev ramfs/proc ramfs/sys ramfs/etc ramfs/root:
	mkdir -p $@

ramfs/init ramfs/linuxrc: $(KMINCDIR)/init
	install -D -m 755 $< $@

ramfs/dev/initrd: | ramfs/dev
	fakeroot -i ramfs.env -s ramfs.env -- mknod -m 400 $@ b 1 250

ramfs/dev/console: | ramfs/dev
	fakeroot -i ramfs.env -s ramfs.env -- mknod -m 622 $@ c 5 1

ramfs/etc/passwd: | ramfs/etc
	echo "root::0:0:root:/root:/bin/sh" >$@

ramfs/etc/group: | ramfs/etc
	echo "root:x:0:root" >$@

initramfs.cpio.gz:

initramfs.cpio: | ramfs/proc ramfs/sys
initramfs.cpio: ramfs/bin/busybox ramfs/dev/console ramfs/init

include init.mk

initramfs.cpio: ramfs/etc/passwd ramfs/etc/group | ramfs/root

%.cpio:
	cd $< && find . | \
	fakeroot -i $(CURDIR)/ramfs.env -s $(CURDIR)/ramfs.env -- \
	cpio -H newc -o -R root:root >$(CURDIR)/$@

%.gz: %
	gzip -9 $*

.PHONY: initramfs_clean
initramfs_clean:
	rm -Rf ramfs/ ramfs.env
	rm -f initramfs.cpio

.PHONY: initramfs_mrproper
initramfs_mrproper:

# ex: filetype=makefile