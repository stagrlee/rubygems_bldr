# Copyright (C) 2008, Lee Thompson
# Basic MIT License
######################################
#Change History
#  09/08/2008  thompson  Original (basic idea from perlmod_bldr...)
#####################################

EXTRA_DIST = configure_pkg.sh get_rubygems.sh

# Add the gems tarballs to the dist after whacking the build directory
# Note, this runs before the tarball release is created.
dist-hook:
	set -e; \
	./get_rubygems.sh -n -d DESTDIR; \
	rsync -qr $(srcdir)/DESTDIR/cache $(distdir)

#quickest way to do this is at the last minute, ie - during install
#and have the script install directly into the DESTDIR
#DESTDIR is only typically available to you during install
install-data-hook:
	./get_rubygems.sh -d ${DESTDIR}${prefix}

clean:
	-@rm -rf DESTDIR
