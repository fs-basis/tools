SUBDIRS = daemon

AM_CPPFLAGS = \
	@FREETYPE_CFLAGS@ \
	-I$(top_srcdir)/include

plugindir = $(PLUGINDIR)

plugin_PROGRAMS = tuxcal.so

tuxcal_so_SOURCES = \
	tuxcal.c \
	rc_device.c

tuxcal_so_LDADD = \
	@FREETYPE_LIBS@ \
	-lz

install-exec-local:
	install -d $(DESTDIR)/var/tuxbox/config/tuxcal
	install -d $(DESTDIR)/var/tuxbox/plugins
	install -m 0755 daemon/tuxcald $(DESTDIR)/var/tuxbox/plugins/
	ln -sf /var/tuxbox/plugins/tuxcald $(DESTDIR)/bin/tuxcald
	install -m 0755 tuxcal.so $(DESTDIR)/var/tuxbox/plugins/
	install -m 0644 tuxcal.cfg $(DESTDIR)/var/tuxbox/plugins/
	install -m 0644 tuxcal_hint.png $(DESTDIR)/var/tuxbox/plugins/
	install -m 0644 tuxcal.conf $(DESTDIR)/var/tuxbox/config/tuxcal/
	install -m 0755 tuxcal.notify $(DESTDIR)/var/tuxbox/config/tuxcal/
