# Copyright (C) 2008, Lee Thompson
# Basic MIT License

AC_INIT([rubygems_core],
        [0.1],
        [Lee Thompson bm55b@yahoo.com])
AC_COPYRIGHT([Copyright (C) 2008, Lee Thompson])
AC_CONFIG_AUX_DIR(config)
AC_PREFIX_DEFAULT([/usr/local])
AM_INIT_AUTOMAKE()

dnl RUBY_HOME
AC_ARG_WITH([ruby],
  AC_HELP_STRING([--with-ruby@<:@=ARG@:>@],
    [The ruby and gems install location @<:@default=/usr/local@:>@]),,
  [with_ruby="/usr/local"])
RUBY_HOME=$with_ruby
AC_SUBST(RUBY_HOME)

AC_CONFIG_FILES([
   Makefile
])

AC_OUTPUT()
