ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = evremote2 evtest

evremote2_SOURCES = \
	evremote.c \
	global.c \
	remotes.c \
	LircdName.c

if BOXMODEL_UFS910
evremote2_SOURCES += \
	Ufs910_1W.c \
	Ufs910_14W.c
else
if BOXMODEL_UFS922
evremote2_SOURCES += \
	Ufs922.c
else
evremote2_SOURCES += \
	Ufs912.c
endif
endif

AM_CFLAGS  = -Wall
AM_LDFLAGS = -lrt -lpthread

evtest_SOURCES = \
	evtest.c
