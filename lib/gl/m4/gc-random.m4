# gc-random.m4 serial 1
dnl Copyright (C) 2005, 2006 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_GC_RANDOM],
[
  # Devices with randomness.
  # FIXME: Are these the best defaults?

  case "${target}" in
    *-openbsd*)
      NAME_OF_RANDOM_DEVICE="/dev/srandom"
      NAME_OF_PSEUDO_RANDOM_DEVICE="/dev/prandom"
      NAME_OF_NONCE_DEVICE="/dev/urandom"
      ;;

    *-netbsd*)
      NAME_OF_RANDOM_DEVICE="/dev/srandom"
      NAME_OF_PSEUDO_RANDOM_DEVICE="/dev/urandom"
      NAME_OF_NONCE_DEVICE="/dev/urandom"
      ;;

    *-solaris* | *-irix* | *-dec-osf* )
      NAME_OF_RANDOM_DEVICE="/dev/random"
      NAME_OF_PSEUDO_RANDOM_DEVICE="/dev/random"
      NAME_OF_NONCE_DEVICE="/dev/random"
      ;;

    *)
      NAME_OF_RANDOM_DEVICE="/dev/random"
      NAME_OF_PSEUDO_RANDOM_DEVICE="/dev/urandom"
      NAME_OF_NONCE_DEVICE="/dev/urandom"
      ;;
  esac

  AC_MSG_CHECKING([device with (strong) random data...])
  AC_ARG_ENABLE(random-device,
	AC_HELP_STRING([--enable-random-device],
		[device with (strong) randomness (for Nettle)]),
	test "$enableval" != "no" && NAME_OF_RANDOM_DEVICE=$enableval)
  AC_MSG_RESULT($NAME_OF_RANDOM_DEVICE)

  AC_MSG_CHECKING([device with pseudo random data...])
  AC_ARG_ENABLE(pseudo-random-device,
	AC_HELP_STRING([--enable-pseudo-random-device],
		[device with pseudo randomness (for Nettle)]),
	test "$enableval" != "no" && NAME_OF_PSEUDO_RANDOM_DEVICE=$enableval)
  AC_MSG_RESULT($NAME_OF_PSEUDO_RANDOM_DEVICE)

  AC_MSG_CHECKING([device with unpredictable data for nonces...])
  AC_ARG_ENABLE(nonce-device,
	AC_HELP_STRING([--enable-nonce-device],
		[device with unpredictable nonces (for Nettle)]),
	test "$enableval" != "no" && NAME_OF_NONCE_DEVICE=$enableval)
  AC_MSG_RESULT($NAME_OF_NONCE_DEVICE)

  if test "$cross_compiling" != yes; then
    AC_CHECK_FILE($NAME_OF_RANDOM_DEVICE,,
      AC_MSG_WARN([[device for (strong) random data `$NAME_OF_RANDOM_DEVICE' does not exist]]))
    AC_CHECK_FILE($NAME_OF_PSEUDO_RANDOM_DEVICE,,
      AC_MSG_WARN([[device for pseudo-random data `$NAME_OF_PSEUDO_RANDOM_DEVICE' does not exist]]))
    AC_CHECK_FILE($NAME_OF_NONCE_DEVICE,,
      AC_MSG_WARN([[device for unpredictable nonces `$NAME_OF_NONCE_DEVICE' does not exist]]))
  else
    AC_MSG_NOTICE([[Cross compiling, assuming random devices exists on the target host...]])  
  fi

  # FIXME?: Open+read 42 bytes+close twice and compare data.  Should differ.

  AC_DEFINE_UNQUOTED(NAME_OF_RANDOM_DEVICE, "$NAME_OF_RANDOM_DEVICE",
                   [defined to the name of the (strong) random device])
  AC_DEFINE_UNQUOTED(NAME_OF_PSEUDO_RANDOM_DEVICE,
			 "$NAME_OF_PSEUDO_RANDOM_DEVICE",
                   [defined to the name of the pseudo random device])
  AC_DEFINE_UNQUOTED(NAME_OF_NONCE_DEVICE, "$NAME_OF_NONCE_DEVICE",
                   [defined to the name of the unpredictable nonce device])

  AC_DEFINE(GC_USE_RANDOM, 1, [Define if you want to support RNG through GC.])
])