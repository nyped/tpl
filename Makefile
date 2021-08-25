DESTDIR ?= /usr/bin
CONFDIR ?= /usr/share

all:
	@echo "Available recipes: install or uninstall"

install:
	@install -v -d ${CONFDIR}/tpl/templates
	@install -vDm0644 src/templates/* ${CONFDIR}/tpl/templates
	@install -vDm0644 src/config ${CONFDIR}/tpl/config
	@install -vDm0755 src/tpl.sh ${DESTDIR}/tpl

uninstall:
	@rm -vrf "${DESTDIR}/tpl"
	@rm -vrf "${CONFDIR}/tpl"

.PHONY: install uninstall all
