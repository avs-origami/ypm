#!/bin/bash
./configure --prefix=/usr       \
        --mandir=/usr/share/man \
        --with-shared           \
        --without-debug         \
        --without-normal        \
        --with-cxx-shared       \
        --enable-pc-files       \
        --enable-widec          \
        --with-pkg-config-libdir=/usr/lib/pkgconfig

make

make DESTDIR=$1/dest install
mkdir -pv $1/usr/lib
install -vm755 $1/dest/usr/lib/libncursesw.so.6.3 $1/usr/lib
rm -v $1/dest/usr/lib/libncursesw.so.6.3
cp -av $1/dest/* $1/
