ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = evremote2 evtest

evremote2_SOURCES = \
	evremote.c \
	global.c \
	remotes.c \
	Ufs910_1W.c \
	Ufs910_14W.c \
	Ufs912.c \
	Ufs922.c \
	LircdName.c

AM_CFLAGS  = -Wall
AM_LDFLAGS = -lrt -lpthread

evtest_SOURCES = \
	evtest.c
