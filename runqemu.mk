#
#  Copyright (C) 2017-2018 Savoir-Faire Linux Inc.
#
#  Authors:
#      Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#

CMDLINE	?=
QEMUFLAGS ?=

.PHONY: all
all:

include initramfs.mk
include kernel.mk

.PHONY: runqemu
runqemu:

runqemu: KERNELFLAG=-kernel bzImage
runqemu: bzImage

runqemu: INITRDFLAG=-initrd initramfs.cpio
runqemu: initramfs.cpio

ifneq (,$(CMDLINE))
runqemu: APPENDFLAG=-append "$(CMDLINE)"
endif

runqemu: QEMUFLAGS?=-serial stdio
runqemu:
	qemu-system-$(shell uname -m) $(KERNELFLAG) $(INITRDFLAG) $(APPENDFLAG) $(QEMUFLAGS)

# ex: filetype=make
