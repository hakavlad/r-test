DESTDIR ?=
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

all:
	@ echo "Use: make install, make uninstall"

install:
	install -p -d $(DESTDIR)$(BINDIR)
	install -p -m0755 r-test $(DESTDIR)$(BINDIR)/r-test
	install -p -m0755 drop-caches $(DESTDIR)$(BINDIR)/drop-caches

uninstall:
	rm -fv $(DESTDIR)$(BINDIR)/r-test
	rm -fv $(DESTDIR)$(BINDIR)/drop-caches
