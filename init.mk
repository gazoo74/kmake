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
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

# ex: filetype=makefile
