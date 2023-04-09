#!/bin/bash
./configure --prefix=/usr      \
	--disable-static       \
        --with-gcc-arch=native \
        --disable-exec-static-tramp

make
make DESTDIR=$1 install
