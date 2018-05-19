# kmake

## NAME

[kmake] - maintain kernel dependencies by extending Kbuild

## DESCRIPTION

[kmake(1)] runs on top of [make(1)] and uses a set of _Makefiles_ to extend the
[Kbuild]'s features.

It enhances the _kernel build-system_ with the build of a tiny _rootfs_ and an
additional [Qemu] target to emulate the _linux kernel_ alongside a _userland_.

The _userland_ is a tiny [InitRAMFS] _cpio_ archive based on a _static_ build of
[busybox(1)]. It contains many common *UNIX* utilities into a single small
executable.

## MAN PAGE

Build the man page using [asciidoctor]

	$ make doc
	asciidoctor -b manpage -o kmake.1 kmake.1.adoc
	gzip -c kmake.1 >kmake.1.gz
	rm kmake.1

## INSTALL

Run the following command to install [kmake(1)]

	$ sudo make install

Traditional variables *DESTDIR* and *PREFIX* can be overridden

	$ sudo make install PREFIX=/opt/kmake

or

	$ make install DESTDIR=$PWD/pkg PREFIX=/usr

## TRY IT

Here is a quick example to try [kmake(1)] on host.

### PREREQUISITES

Fetch the [kernel] sources using the target `linux_download` from [kmake(1)]

	$ make linux_download
	...

Go in the sources and configure _linux_ using the host features and save the
configuration into _.config_ file

	$ cd linux
	$ make menuconfig 
	  HOSTCC  scripts/basic/fixdep
	  HOSTCC  scripts/kconfig/mconf.o
	  YACC    scripts/kconfig/zconf.tab.c
	  LEX     scripts/kconfig/zconf.lex.c
	  HOSTCC  scripts/kconfig/zconf.tab.o
	  HOSTCC  scripts/kconfig/lxdialog/checklist.o
	  HOSTCC  scripts/kconfig/lxdialog/util.o
	  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
	  HOSTCC  scripts/kconfig/lxdialog/textbox.o
	  HOSTCC  scripts/kconfig/lxdialog/yesno.o
	  HOSTCC  scripts/kconfig/lxdialog/menubox.o
	  HOSTLD  scripts/kconfig/mconf
	scripts/kconfig/mconf  Kconfig
	#
	# using defaults found in arch/x86/configs/x86_64_defconfig
	#
	configuration written to .config

	*** End of the configuration.
	*** Execute 'make' to start the build or try 'make help'.

### THE KERNEL IMAGE

Use [kmake(1)] to build the _kernel_ image

	$ kmake

_Note_: It is equivalent to run [make(1)]

	$ make

### THE USERLAND ARCHIVE

Fetch the [busybox] sources using the target `busybox_download` from [kmake(1)]

	$ kmake busybox_download
	...

\... and then use [kmake(1)] to build the _userland_ archive

	$ kmake initramfs.cpio

### EMULATE

Use the target `runqemu` from [kmake(1)] to emulate the _kernel_ alongside the
_userland_ using [qemu(1)]

	$ kmake runqemu

## LINKS

Check for [kmake(1)] man-page and its [examples].

Enjoy!

## BUGS

Report bugs at *https://github.com/gazoo74/kmake/issues*

## AUTHOR

Written by Gaël PORTAY *gael.portay@savoirfairelinux.com*

## COPYRIGHT

Copyright (C) 2018 Savoir-Faire Linux Inc.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

## SEE ALSO

[make(1)], [busybox(1)], [qemu(1)]

[kmake]: kmake
[kmake(1)]: kmake.1.adoc
[examples]: kmake.1.adoc#examples
[make(1)]: https://www.gnu.org/software/make/manual/make.html#Running
[kernel]: https://www.kernel.org/
[Kbuild]: https://www.kernel.org/doc/Documentation/kbuild/makefiles.txt
[InitRAMFS]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/ramfs-rootfs-initramfs.txt
[asciidoctor]: https://asciidoctor.org/
[busybox]: https://busybox.net/
[busybox(1)]: https://busybox.net/downloads/BusyBox.html
[Qemu]: https://www.qemu.org/
[qemu(1)]: https://github.com/qemu/qemu
