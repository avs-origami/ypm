#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --docdir=/usr/share/doc/gettext-0.21

make
make DESTDIR=$1 install
chmod -v 0755 $1/usr/lib/preloadable_libintl.so
