ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = evremote2 evtest

evremote2_SOURCES = \
	evremote.c \
	global.c \
	remotes.c \
	Ufs910_1W.c \
	Ufs910_14W.c \
	Tf7700.c \
	Ufs912.c \
	Spark.c \
	Ufs922.c \
	Fortis.c \
	Cuberevo.c \
	Ipbox.c \
	LircdName.c

AM_CFLAGS  = -Wall
AM_LDFLAGS = -lrt -lpthread

evtest_SOURCES = \
	evtest.c
