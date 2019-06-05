#
#  Copyright (C)      2019 Gaël PORTAY
#                2017-2018 Savoir-Faire Linux Inc.
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

runqemu: KERNELFLAG=-kernel $(KBUILD_IMAGE)
runqemu: $(KBUILD_IMAGE)

runqemu: INITRDFLAG=-initrd initramfs.cpio
runqemu: initramfs.cpio

ifneq (,$(CMDLINE))
runqemu: APPENDFLAG=-append "$(CMDLINE)"
endif

runqemu: QEMUFLAGS?=-serial stdio
runqemu:
	qemu-system-$(MACHARCH) $(KERNELFLAG) $(INITRDFLAG) $(APPENDFLAG) $(QEMUFLAGS)

# ex: filetype=make
