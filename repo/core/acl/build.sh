#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --docdir=/usr/share/doc/acl-2.3.1

make
make DESTDIR=$1 install
