#
#  Copyright (C) 2019 Gaël PORTAY
#                2018 Savoir-Faire Linux Inc.
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

PREFIX ?= /usr/local
DESTDIR ?=

.PHONY: all
all:

.PHONY: doc
doc: kmake.1.gz

.PHONY: install-all
install-all: install install-doc install-bash-completion

.PHONY: install
install:
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -m 755 kmake $(DESTDIR)$(PREFIX)/bin/
	sed -e 's,/usr/,$(PREFIX)/,' \
	    -i $(DESTDIR)$(PREFIX)/bin/kmake
	install -d $(DESTDIR)$(PREFIX)/share/kmake/
	install -m 644 kmakefile *.mk init inittab rcS \
	           $(DESTDIR)$(PREFIX)/share/kmake/

.PHONY: install-doc
install-doc:
	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
	install -m 644 kmake.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/

.PHONY: install-bash-completion
install-bash-completion:
	completionsdir=$${BASHCOMPLETIONSDIR:-$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion)}; \
	if [ -n "$$completionsdir" ]; then \
		install -d $(DESTDIR)$$completionsdir/; \
		install -m 644 bash-completion $(DESTDIR)$$completionsdir/kmake; \
	fi

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/kmake
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/kmake.1.gz
	completionsdir=$$(pkg-config --define-variable=prefix=$(PREFIX) \
	                             --variable=completionsdir \
	                             bash-completion); \
	if [ -n "$$completionsdir" ]; then \
		rm -f $(DESTDIR)$$completionsdir/kmake; \
	fi

.PHONY: user-install-all
user-install-all: user-install user-install-doc user-install-bash-completion

user-install user-install-doc user-install-bash-completion user-uninstall:
user-%:
	$(MAKE) $* PREFIX=$$HOME/.local BASHCOMPLETIONSDIR=$$HOME/.local/share/bash-completion/completions

.PHONY: check
check: kmake
	shellcheck $^

.PHONY: clean
clean:
	rm -f kmake.1.gz

.PHONY: mrproper
mrproper: clean
	rm -f linux
	rm -Rf linux-*/

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $^ >$@

# ex: filetype=make
