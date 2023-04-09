#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --sysconfdir=/etc \
        --docdir=/usr/share/doc/attr-2.5.1

make
make check
make DESTDIR=$1 install
