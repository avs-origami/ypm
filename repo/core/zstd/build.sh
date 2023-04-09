#!/bin/bash
patch -Np1 -i ../zstd-1.5.2-upstream_fixes-1.patch

make prefix=/usr
make check
make prefix=/usr DESTDIR=$1 install

rm -v $1/usr/lib/libzstd.a
