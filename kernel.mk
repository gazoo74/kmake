#
#  Copyright (C)      2019 Gaël PORTAY
#                2017-2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

.PHONY: all
all:

.PHONY: clean
clean: linux_clean

.PHONY: mrproper
mrproper: linux_mrproper

include subarch.mk

ifneq ($(KBUILD_IMAGE),)
.SILENT: $(KBUILD_IMAGE)
$(obj)/$(KBUILD_IMAGE): $(obj)/.config
	$(MAKE) -f Makefile $(KMAKE_JOBS)
endif

.SILENT: .config
$(obj)/.config: | Makefile
	echo "You need to configure your kernel!" >&2
	exit 1

.SILENT: Makefile
Makefile:
	echo "You need to provide your own kernel sources into the $(CURDIR)/$(@D) directory!" >&2
	echo "Have a look at https://www.kernel.org! or run one of the commands below:" >&2
	echo "$$ git clone git@github.com:torvalds/linux.git $(CURDIR)/$(@D)" >&2
	echo "or" >&2
	echo "$$ $(MAKE) $(@D)_download" >&2
	exit 1

.SILENT: linux_download
linux_download:
	wget -qO- https://www.kernel.org/index.html | \
	sed -n '/<td id="latest_link"/,/<\/td>/s,.*<a.*href="\(.*\)">\(.*\)</a>.*,wget -qO- \1 | tar xvJ \&\& ln -sf linux-\2 linux,p' | \
	$(SHELL)

.PHONY: linux_source
linux_source:
	git clone --single-branch git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux

$(obj)/rootfs/lib/modules/%/modules.order: modules.order
	$(MAKE) modules_install INSTALL_MOD_PATH=$(CURDIR)/$(firstword $(subst /, ,$(@D)))


linux_%:
	@$(MAKE) $*

# ex: filetype=make
