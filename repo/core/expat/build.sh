#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --docdir=/usr/share/doc/expat-2.5.0

make
make DESTDIR=$1 install
