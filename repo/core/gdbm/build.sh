#!/bin/bash
./configure --prefix=/usr \
	--disable-static  \
        --enable-libgdbm-compat

make
make DESTDIR=$1 install
