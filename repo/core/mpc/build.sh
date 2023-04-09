#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --docdir=/usr/share/doc/mpc-1.2.1

make
make html
make check
make DESTDIR=$1 install
make DESTDIR=$1 install-html
