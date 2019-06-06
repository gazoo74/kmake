#
#  Copyright (C) 2019 Gaël PORTAY
#
# SPDX-License-Identifier: GPL-2.0
#

# The following part is taken and adapted from the kernel sources.

# SUBARCH tells the usermode build what the underlying arch is.  That is set
# first, and if a usermode build is happening, the "ARCH=um" on the command
# line overrides the setting of ARCH below.  If a native build is happening,
# then ARCH is assigned, getting whatever value it gets normally, and
# SUBARCH is subsequently ignored.

SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
				  -e s/arm.*/arm/ -e s/sa110/arm/ \
				  -e s/aarch64.*/arm64/)

# Cross compiling and selecting different set of gcc/bin-utils
# ---------------------------------------------------------------------------
#
# When performing cross compilation for other architectures ARCH shall be set
# to the target architecture. (Only x86 and ARM 32/64bits supported).
# ARCH can be set during invocation of kmake:
# kmake ARCH=i386
# Another way is to have ARCH set in the environment.
# The default ARCH is the host where kmake is executed.

# CROSS_COMPILE specify the prefix used for all executables used
# during compilation. Only gcc and related bin-utils executables
# are prefixed with $(CROSS_COMPILE).
# CROSS_COMPILE can be set on the command line
# kmake CROSS_COMPILE=i686-linux-
# Alternatively CROSS_COMPILE can be set in the environment.
# Default value for CROSS_COMPILE is not to prefix executables
ARCH		?= $(SUBARCH)
SRCARCH		:= $(ARCH)
MACHARCH	:= $(shell uname -m)
KBUILD_IMAGE	?= arch/$(SRCARCH)/boot/bzImage

# Additional ARCH settings for x86
ifeq ($(ARCH),i386)
	SRCARCH := x86
	MACHARCH := i386
endif
ifeq ($(ARCH),x86_64)
	SRCARCH := x86
	MACHARCH := x86_64
	KBUILD_IMAGE := arch/$(SRCARCH)/boot/bzImage
endif

# Additional ARCH settings for ARM
ifeq ($(ARCH),arm)
	MACHARCH := arm
	KBUILD_IMAGE := arch/$(SRCARCH)/boot/zImage
	MACHINEFLAG ?= -machine type=virt -smp 1 -m 8192
	CMDLINE ?= console=ttyAMA0
endif
ifeq ($(ARCH),arm64)
	MACHARCH := aarch64
	KBUILD_IMAGE := arch/$(SRCARCH)/boot/Image.gz
	MACHINEFLAG ?= -cpu cortex-a57 -machine type=virt -smp 1 -m 8192
	CMDLINE ?= console=ttyAMA0
endif
