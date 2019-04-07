#
#  Copyright (C) 2017-2018 Savoir-Faire Linux Inc.
#
#  Authors:
#      Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

.PHONY: clean
clean: linux_clean

.PHONY: mrproper
mrproper: linux_mrproper

bzImage: arch/x86/boot/bzImage
	cp $< $@

.SILENT: arch/x86/boot/bzImage
arch/x86/boot/bzImage: .config
	$(MAKE) -f Makefile

.SILENT: linux_download
linux_download:
	wget -qO- https://www.kernel.org/index.html | \
	sed -n '/<td id="latest_link"/,/<\/td>/s,.*<a.*href="\(.*\)">\(.*\)</a>.*,wget -qO- \1 | tar xvJ \&\& ln -sf linux-\2 linux,p' | \
	$(SHELL)

.PHONY: linux_source
linux_source:
	git clone --single-branch git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux

linux_%:
	@$(MAKE) $*

# ex: filetype=make
