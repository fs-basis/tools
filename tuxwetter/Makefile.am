AM_CPPFLAGS = \
	-DWWEATHER \
	@FREETYPE_CFLAGS@ \
	@CURL_CFLAGS@ \
	@PNG_CFLAGS@ \
	-I$(top_srcdir)/include

tuxwetter_LDADD = \
	@FREETYPE_LIBS@ \
	@CURL_LIBS@ \
	@PNG_LIBS@ \
	-lcrypto \
	-lssl \
	-ljpeg \
	-lgif

noinst_PROGRAMS = tuxwetter

tuxwetter_SOURCES = \
	tuxwetter.c \
	gfx.c \
	io.c \
	text.c \
	parser.c \
	php.c \
	http.c \
	jpeg.c \
	fb_display.c \
	resize.c \
	pngw.cpp \
	png_helper.cpp \
	gif.c \
	gifdecomp.c

install-exec-local:
	install -d $(DESTDIR)/var/tuxbox/plugins
	install -d $(DESTDIR)/var/tuxbox/config
	install -d $(DESTDIR)/var/tuxbox/config/tuxwetter
	install -m 0755 tuxwetter $(DESTDIR)/var/tuxbox/plugins/tuxwetter.so
	install -m 0644 $(srcdir)/tuxwetter.cfg $(DESTDIR)/var/tuxbox/plugins
	install -m 0644 $(srcdir)/tuxwetter.conf $(srcdir)/tuxwetter.mcfg $(srcdir)/convert.list $(srcdir)/startbild.jpg $(srcdir)/tuxwetter.png $(DESTDIR)/var/tuxbox/config/tuxwetter
	install -m 0644 $(srcdir)/tuxwetter_hint.png $(DESTDIR)/var/tuxbox/plugins
	ln -s /var/tuxbox/plugins/tuxwetter.so $(DESTDIR)/bin/tuxwetter
