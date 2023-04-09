#!/bin/bash
./configure --prefix=/usr    \
	--disable-debuginfod \
        --enable-libdebuginfod=dummy

make
make -C libelf DESTDIR=$1 install

mkdir -pv $1/usr/lib/pkgconfig
install -vm644 config/libelf.pc $1/usr/lib/pkgconfig
rm $1/usr/lib/libelf.a
