#!/bin/sh
# Clean out the package of all machine made files
rm -rf autom4te.cache aclocal.m4 config DESTDIR gems
# Now recreate those machine made files and collect the gem tarballs
autoreconf -i
./configure
# package generated and man made stuff into a tarball
make dist
