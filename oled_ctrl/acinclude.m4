AC_DEFUN([TUXBOX_APPS], [
AM_CONFIG_HEADER(config.h)
AM_MAINTAINER_MODE

AC_GNU_SOURCE

AC_ARG_WITH(target,
	AS_HELP_STRING([--with-target=TARGET], [target for compilation [[native,cdk]]]),
	[TARGET="$withval"],
	[TARGET="native"])

AC_ARG_WITH(targetprefix,
	AS_HELP_STRING([--with-targetprefix=PATH], [prefix relative to target root (only applicable in cdk mode)]),
	[TARGET_PREFIX="$withval"],
	[TARGET_PREFIX=""])

AC_ARG_WITH(debug,
	AS_HELP_STRING([--without-debug], [disable debugging code @<:@default=no@:>@]),
	[DEBUG="$withval"],
	[DEBUG="yes"])

if test "$DEBUG" = "yes"; then
	DEBUG_CFLAGS="-g3 -ggdb"
	AC_DEFINE(DEBUG, 1, [enable debugging code])
fi

AC_MSG_CHECKING(target)

if test "$TARGET" = "native"; then
	AC_MSG_RESULT(native)

	if test "$CFLAGS" = "" -a "$CXXFLAGS" = ""; then
		CFLAGS="-Wall -O2 -pipe $DEBUG_CFLAGS"
		CXXFLAGS="-Wall -O2 -pipe $DEBUG_CFLAGS"
	fi
	if test "$prefix" = "NONE"; then
		prefix=/usr/local
	fi
	targetprefix=$prefix
	TARGET_PREFIX=$prefix
	AC_DEFINE_UNQUOTED(TARGET_PREFIX, "$TARGET_PREFIX", [The targets prefix])
elif test "$TARGET" = "cdk"; then
	AC_MSG_RESULT(cdk)

	if test "$CC" = "" -a "$CXX" = ""; then
		AC_MSG_ERROR([you need to specify variables CC or CXX in cdk])
	fi
	if test "$CFLAGS" = "" -o "$CXXFLAGS" = ""; then
		AC_MSG_ERROR([you need to specify variables CFLAGS and CXXFLAGS in cdk])
	fi
	if test "$prefix" = "NONE"; then
		AC_MSG_ERROR([invalid prefix, you need to specify one in cdk mode])
	fi
	if test "$TARGET_PREFIX" != "NONE"; then
		AC_DEFINE_UNQUOTED(TARGET_PREFIX, "$TARGET_PREFIX", [The targets prefix])
	fi
	if test "$TARGET_PREFIX" = "NONE"; then
		AC_MSG_ERROR([invalid targetprefix, you need to specify one in cdk mode])
		TARGET_PREFIX=""
	fi
else
	AC_MSG_RESULT(none)
	AC_MSG_ERROR([invalid target $TARGET, choose on from native,cdk]);
fi

if test "$exec_prefix" = "NONE"; then
	exec_prefix=$prefix
fi

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SYS_LARGEFILE

])

dnl expand nested ${foo}/bar
AC_DEFUN([TUXBOX_EXPAND_VARIABLE], [
	__$1="$2"
	for __CNT in false false false false true; do dnl max 5 levels of indirection
		$1=`eval echo "$__$1"`
		echo ${$1} | grep -q '\$' || break # 'grep -q' is POSIX, exit if no $ in variable
		__$1="${$1}"
	done
	$__CNT && AC_MSG_ERROR([can't expand variable $1=$2]) dnl bail out if we did not expand
])

AC_DEFUN([TUXBOX_APPS_DIRECTORY_ONE], [
AC_ARG_WITH($1, AS_HELP_STRING([$6], [$7 [[PREFIX$4$5]]], [32], [79]), [
	_$2=$withval
	if test "$TARGET" = "cdk"; then
		$2=`eval echo "$TARGET_PREFIX$withval"` # no indirection possible IMNSHO
	else
		$2=$withval
	fi
	TARGET_$2=${$2}
], [
	# RFC 1925: "you can always add another level of indirection..."
	TUXBOX_EXPAND_VARIABLE($2,"${$3}$5")
	if test "$TARGET" = "cdk"; then
		TUXBOX_EXPAND_VARIABLE(_$2,"${target$3}$5")
	else
		_$2=${$2}
	fi
	TARGET_$2=$_$2
])
dnl AC_SUBST($2)
AC_DEFINE_UNQUOTED($2,"$_$2",$7)
AC_SUBST(TARGET_$2)
])

AC_DEFUN([TUXBOX_APPS_DIRECTORY], [
AC_REQUIRE([TUXBOX_APPS])

if test "$TARGET" = "cdk"; then
	datadir="\${prefix}/share"
	sysconfdir="\${prefix}/etc"
	localstatedir="\${prefix}/var"
	libdir="\${prefix}/lib"
	targetdatadir="\${TARGET_PREFIX}/share"
	targetsysconfdir="\${TARGET_PREFIX}/etc"
	targetlocalstatedir="\${TARGET_PREFIX}/var"
	targetlibdir="\${TARGET_PREFIX}/lib"
fi

TUXBOX_APPS_DIRECTORY_ONE(configdir, CONFIGDIR, localstatedir, /var, /tuxbox/config,
	[--with-configdir=PATH], [where to find config files])

TUXBOX_APPS_DIRECTORY_ONE(datadir, DATADIR, datadir, /share, /tuxbox,
	[--with-datadir=PATH], [where to find data files])

TUXBOX_APPS_DIRECTORY_ONE(fontdir, FONTDIR, datadir, /share, /fonts,
	[--with-fontdir=PATH], [where to find fonts])

TUXBOX_APPS_DIRECTORY_ONE(libdir, LIBDIR, libdir, /lib, /tuxbox,
	[--with-libdir=PATH], [where to find internal libs])

TUXBOX_APPS_DIRECTORY_ONE(plugindir, PLUGINDIR, localstatedir, /var, /tuxbox/plugins,
	[--with-plugindir=PATH], [where to find plugins in /var])

TUXBOX_APPS_DIRECTORY_ONE(themesdir, THEMESDIR, datadir, /share, /tuxbox/neutrino/themes,
	[--with-themesdir=PATH], [where to find themes])
])

dnl automake <= 1.6 needs this specifications
AC_SUBST(CONFIGDIR)
AC_SUBST(DATADIR)
AC_SUBST(FONTDIR)
AC_SUBST(LIBDIR)
AC_SUBST(PLUGINDIR)
AC_SUBST(THEMESDIR)
dnl end workaround

AC_DEFUN([TUXBOX_BOXTYPE], [
AC_ARG_WITH(boxtype,
	AS_HELP_STRING([--with-boxtype], [valid values: armbox, duckbox, mipsbox, spark, spark7162]),
	[case "${withval}" in
		ufs*)
			BOXTYPE="duckbox"
			BOXMODEL="$withval"
		;;
		spark|spark7162)
			BOXTYPE="spark"
			BOXMODEL="$withval"
		;;
		bre2ze4k|h7|hd51|e4hdultra|vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuzero4k|vuuno4kse|vuuno4k)
			BOXTYPE="armbox"
			BOXMODEL="$withval"
		;;
		vuduo)
			BOXTYPE="mipsbox"
			BOXMODEL="$withval"
		;;
		*)
			AC_MSG_ERROR([bad value $withval for --with-boxtype])
		;;
	esac])

AC_ARG_WITH(boxmodel,
	AS_HELP_STRING([--with-boxmodel], [valid for duckbox: ufs910, ufs912, ufs913, ufs922])
AS_HELP_STRING([], [valid for duckbox: ufs910, ufs912, ufs913, ufs922])
AS_HELP_STRING([], [valid for spark: spark, spark7162])
AS_HELP_STRING([], [valid for armbox: bre2ze4k, h7, hd51, e4hdultra, vusolo4k, vuduo4k, vuduo4kse, vuultimo4k, vuzero4k, vuuno4kse, vuuno4k])
AS_HELP_STRING([], [valid for mipsbox: vuduo]),
	[case "${withval}" in
		ufs910|ufs912|ufs913|ufs922)
			if test "$BOXTYPE" = "duckbox"; then
				BOXMODEL="$withval"
			else
				AC_MSG_ERROR([unknown model $withval for boxtype $BOXTYPE])
			fi
		;;
		spark|spark7162)
			if test "$BOXTYPE" = "spark"; then
				BOXMODEL="$withval"
			else
				AC_MSG_ERROR([unknown model $withval for boxtype $BOXTYPE])
			fi
		;;
		bre2ze4k|h7|hd51|e4hdultra|vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuzero4k|vuuno4kse|vuuno4k)
			if test "$BOXTYPE" = "armbox"; then
				BOXMODEL="$withval"
			else
				AC_MSG_ERROR([unknown model $withval for boxtype $BOXTYPE])
			fi
		;;
		vuduo)
			if test "$BOXTYPE" = "mipsbox"; then
				BOXMODEL="$withval"
			else
				AC_MSG_ERROR([unknown model $withval for boxtype $BOXTYPE])
			fi
		;;
		*)
			AC_MSG_ERROR([unsupported value $withval for --with-boxmodel])
		;;
	esac])

AC_SUBST(BOXTYPE)
AC_SUBST(BOXMODEL)

AM_CONDITIONAL(BOXTYPE_DUCKBOX, test "$BOXTYPE" = "duckbox")
AM_CONDITIONAL(BOXTYPE_SPARK, test "$BOXTYPE" = "spark")
AM_CONDITIONAL(BOXTYPE_ARMBOX, test "$BOXTYPE" = "armbox")
AM_CONDITIONAL(BOXTYPE_MIPSBOX, test "$BOXTYPE" = "mipsbox")

AM_CONDITIONAL(BOXMODEL_UFS910, test "$BOXMODEL" = "ufs910")
AM_CONDITIONAL(BOXMODEL_UFS912, test "$BOXMODEL" = "ufs912")
AM_CONDITIONAL(BOXMODEL_UFS913, test "$BOXMODEL" = "ufs913")
AM_CONDITIONAL(BOXMODEL_UFS922, test "$BOXMODEL" = "ufs922")

AM_CONDITIONAL(BOXMODEL_SPARK, test "$BOXMODEL" = "spark")
AM_CONDITIONAL(BOXMODEL_SPARK7162, test "$BOXMODEL" = "spark7162")

AM_CONDITIONAL(BOXMODEL_BRE2ZE4K, test "$BOXMODEL" = "bre2ze4k")
AM_CONDITIONAL(BOXMODEL_H7, test "$BOXMODEL" = "h7")
AM_CONDITIONAL(BOXMODEL_HD51, test "$BOXMODEL" = "hd51")
AM_CONDITIONAL(BOXMODEL_E4HDULTRA, test "$BOXMODEL" = "e4hdultra")

AM_CONDITIONAL(BOXMODEL_VUSOLO4K, test "$BOXMODEL" = "vusolo4k")
AM_CONDITIONAL(BOXMODEL_VUDUO4K, test "$BOXMODEL" = "vuduo4k")
AM_CONDITIONAL(BOXMODEL_VUDUO4KSE, test "$BOXMODEL" = "vuduo4kse")
AM_CONDITIONAL(BOXMODEL_VUULTIMO4K, test "$BOXMODEL" = "vuultimo4k")
AM_CONDITIONAL(BOXMODEL_VUZERO4K, test "$BOXMODEL" = "vuzero4k")
AM_CONDITIONAL(BOXMODEL_VUUNO4KSE, test "$BOXMODEL" = "vuuno4kse")
AM_CONDITIONAL(BOXMODEL_VUUNO4K, test "$BOXMODEL" = "vuuno4k")
AM_CONDITIONAL(BOXMODEL_VUDUO, test "$BOXMODEL" = "vuduo")

AM_CONDITIONAL(BOXMODEL_VUPLUS_ALL, test "$BOXMODEL" = "vusolo4k" -o "$BOXMODEL" = "vuduo4k" -o "$BOXMODEL" = "vuduo4kse" -o "$BOXMODEL" = "vuultimo4k" -o "$BOXMODEL" = "vuzero4k" -o "$BOXMODEL" = "vuuno4kse" -o "$BOXMODEL" = "vuuno4k" -o "$BOXMODEL" = "vuduo")
AM_CONDITIONAL(BOXMODEL_VUPLUS_ARM, test "$BOXMODEL" = "vusolo4k" -o "$BOXMODEL" = "vuduo4k" -o "$BOXMODEL" = "vuduo4kse" -o "$BOXMODEL" = "vuultimo4k" -o "$BOXMODEL" = "vuzero4k" -o "$BOXMODEL" = "vuuno4kse" -o "$BOXMODEL" = "vuuno4k")
AM_CONDITIONAL(BOXMODEL_VUPLUS_MIPS, test "$BOXMODEL" = "vuduo")

if test "$BOXTYPE" = "duckbox"; then
	AC_DEFINE(HAVE_DUCKBOX_HARDWARE, 1, [building for a duckbox])
	AC_DEFINE(HAVE_SH4_HARDWARE, 1, [building for a sh4 box])
elif test "$BOXTYPE" = "spark"; then
	AC_DEFINE(HAVE_SPARK_HARDWARE, 1, [building for a goldenmedia 990 or edision pingulux])
	AC_DEFINE(HAVE_SH4_HARDWARE, 1, [building for a sh4 box])
elif test "$BOXTYPE" = "armbox"; then
	AC_DEFINE(HAVE_ARM_HARDWARE, 1, [building for an armbox])
elif test "$BOXTYPE" = "mipsbox"; then
	AC_DEFINE(HAVE_MIPS_HARDWARE, 1, [building for an mipsbox])
fi

# TODO: do we need more defines?
if test "$BOXMODEL" = "ufs910"; then
	AC_DEFINE(BOXMODEL_UFS910, 1, [ufs910])
elif test "$BOXMODEL" = "ufs912"; then
	AC_DEFINE(BOXMODEL_UFS912, 1, [ufs912])
elif test "$BOXMODEL" = "ufs913"; then
	AC_DEFINE(BOXMODEL_UFS913, 1, [ufs913])
elif test "$BOXMODEL" = "ufs922"; then
	AC_DEFINE(BOXMODEL_UFS922, 1, [ufs922])
elif test "$BOXMODEL" = "spark"; then
	AC_DEFINE(BOXMODEL_SPARK, 1, [spark])
elif test "$BOXMODEL" = "spark7162"; then
	AC_DEFINE(BOXMODEL_SPARK7162, 1, [spark7162])
elif test "$BOXMODEL" = "bre2ze4k"; then
	AC_DEFINE(BOXMODEL_BRE2ZE4K, 1, [bre2ze4k])
elif test "$BOXMODEL" = "h7"; then
	AC_DEFINE(BOXMODEL_H7, 1, [h7])
elif test "$BOXMODEL" = "hd51"; then
	AC_DEFINE(BOXMODEL_HD51, 1, [hd51])
elif test "$BOXMODEL" = "e4hdultra"; then
	AC_DEFINE(BOXMODEL_E4HDULTRA, 1, [e4hdultra])
elif test "$BOXMODEL" = "vusolo4k"; then
	AC_DEFINE(BOXMODEL_VUSOLO4K, 1, [vusolo4k])
elif test "$BOXMODEL" = "vuduo4k"; then
	AC_DEFINE(BOXMODEL_VUDUO4K, 1, [vuduo4k])
elif test "$BOXMODEL" = "vuduo4kse"; then
	AC_DEFINE(BOXMODEL_VUDUO4KSE, 1, [vuduo4kse])
elif test "$BOXMODEL" = "vuultimo4k"; then
	AC_DEFINE(BOXMODEL_VUULTIMO4K, 1, [vuultimo4k])
elif test "$BOXMODEL" = "vuzero4k"; then
	AC_DEFINE(BOXMODEL_VUZERO4K, 1, [vuzero4k])
elif test "$BOXMODEL" = "vuuno4kse"; then
	AC_DEFINE(BOXMODEL_VUUNO4KSE, 1, [vuuno4kse])
elif test "$BOXMODEL" = "vuuno4k"; then
	AC_DEFINE(BOXMODEL_VUUNO4K, 1, [vuuno4k])
elif test "$BOXMODEL" = "vuduo"; then
	AC_DEFINE(BOXMODEL_VUDUO, 1, [vuduo])
fi

# all vuplus BOXMODELs
case "$BOXMODEL" in
	vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuuno4k|vuuno4kse|vuzero4k|vuduo)
		AC_DEFINE(BOXMODEL_VUPLUS_ALL, 1, [vuplus_all])
	;;
esac

# all vuplus arm BOXMODELs
case "$BOXMODEL" in
	vusolo4k|vuduo4k|vuduo4kse|vuultimo4k|vuuno4k|vuuno4kse|vuzero4k)
		AC_DEFINE(BOXMODEL_VUPLUS_ARM, 1, [vuplus_arm])
	;;
esac

# all vuplus mips BOXMODELs
case "$BOXMODEL" in
	vuduo)
		AC_DEFINE(BOXMODEL_VUPLUS_MIPS, 1, [vuplus_mips])
	;;
esac
])

dnl backward compatiblity
AC_DEFUN([AC_GNU_SOURCE], [
AH_VERBATIM([_GNU_SOURCE], [
/* Enable GNU extensions on systems that have them. */
#ifndef _GNU_SOURCE
# undef _GNU_SOURCE
#endif
])dnl
AC_BEFORE([$0], [AC_COMPILE_IFELSE])dnl
AC_BEFORE([$0], [AC_RUN_IFELSE])dnl
AC_DEFINE([_GNU_SOURCE])
])

AC_DEFUN([AC_PROG_EGREP], [
AC_CACHE_CHECK([for egrep], [ac_cv_prog_egrep], [
if echo a | (grep -E '(a|b)') >/dev/null 2>&1; then
	ac_cv_prog_egrep='grep -E'
else
	ac_cv_prog_egrep='egrep'
fi
])
EGREP=$ac_cv_prog_egrep
AC_SUBST([EGREP])
])
