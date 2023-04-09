#!/bin/bash
./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.2.6

make
make check
make DESTDIR=$1 install
