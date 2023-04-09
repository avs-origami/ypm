#!/bin/bash
./configure --prefix=/usr    \
	--disable-static     \
        --enable-thread-safe \
        --docdir=/usr/share/doc/mpfr-4.1.0

make
make html
make check
make DESTDIR=$1 install
make DESTDIR=$1 install-html
