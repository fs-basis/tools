ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = fp_control

fp_control_SOURCES = \
	fp_control.c \
	global.c
if BOXMODEL_UFS910
fp_control_SOURCES += \
	Ufs910_1W.c \
	Ufs910_14W.c
else
if BOXMODEL_UFS922
fp_control_SOURCES += \
	Ufs922.c
else
fp_control_SOURCES += \
	Ufs912.c
endif
endif

AM_CFLAGS  = -Wall
AM_LDFLAGS = -lrt
